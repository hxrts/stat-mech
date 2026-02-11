#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LEAN_DIR="${ROOT_DIR}/Gibbs"

if ! command -v rg >/dev/null 2>&1; then
  echo "error: ripgrep (rg) is required" >&2
  exit 2
fi

STRICT=0
if [[ "${1:-}" == "--strict" ]]; then
  STRICT=1
  shift
fi
if [[ $# -ne 0 ]]; then
  echo "usage: $0 [--strict]" >&2
  exit 2
fi

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

errors=0
warnings=0
summary_lines=""

print_section() {
  echo ""
  echo -e "${BLUE}== $1 ==${NC}"
}

print_hits() {
  local severity="$1"
  local title="$2"
  local matches="$3"
  local recommendation="$4"
  local count=0

  if [[ -n "${matches}" ]]; then
    count="$(printf '%s\n' "${matches}" | sed '/^$/d' | wc -l | tr -d ' ')"
  fi

  if [[ "${count}" == "0" ]]; then
    echo -e "${GREEN}OK${NC}  ${title}"
    summary_lines+="OK\t\"${title}\"\t0\n"
    return
  fi

  if [[ "${severity}" == "error" ]]; then
    errors=$((errors + count))
    echo -e "${RED}VIOLATION${NC}  ${title} (${count})"
    summary_lines+="ERROR\t\"${title}\"\t${count}\n"
  else
    warnings=$((warnings + count))
    echo -e "${YELLOW}WARNING${NC}  ${title} (${count})"
    summary_lines+="WARN\t\"${title}\"\t${count}\n"
  fi

  if [[ -n "${recommendation}" ]]; then
    echo "Recommended action: ${recommendation}"
  fi

  printf '%s\n' "${matches}" | sed -n '1,30p'
  if [[ "${count}" -gt 30 ]]; then
    echo "... (${count} total, truncated to 30)"
  fi
}

scan_rg() {
  local pattern="$1"
  rg -n --pcre2 "${pattern}" "${LEAN_DIR}" \
    -g '*.lean' \
    -g '!.lake/**' \
    -g '!**/.lake/**' \
    -g '!target/**' \
    -g '!**/target/**' || true
}

collect_file_metric_hits() {
  local mode="$1"
  local threshold="$2"
  local out=""

  while IFS= read -r file; do
    local line_count
    line_count="$(wc -l < "${file}" | tr -d ' ')"
    if (( line_count <= threshold )); then
      continue
    fi

    # Exclude obvious test/example/debug modules from style checks.
    if [[ "${file}" =~ /Tests/ ]] || [[ "${file}" =~ /Examples/ ]] || [[ "${file}" =~ MutualTest ]]; then
      continue
    fi

    case "${mode}" in
      file_length)
        out+="${file}:${line_count}: exceeds style guide file-length threshold (${threshold})"$'\n'
        ;;
      section_headers)
        if ! rg -q '/-![[:space:]]*##[[:space:]]+' "${file}"; then
          out+="${file}:${line_count}: missing section headers (/-! ## ... -/)"$'\n'
        fi
        ;;
      module_doc)
        if ! rg -q '/-![[:space:]]*#[[:space:]]+' "${file}"; then
          out+="${file}:${line_count}: missing module doc block (/-! # ... -/)"$'\n'
        fi
        ;;
      *)
        echo "internal error: unknown mode ${mode}" >&2
        exit 2
        ;;
    esac
  done < <(find "${LEAN_DIR}" -type f -name '*.lean' -not -path '*/.lake/*' -not -path '*/target/*' | sort)

  printf '%s\n' "${out}" | sed '/^$/d' || true
}

# Check for undocumented axioms (axioms not in Axioms.lean)
check_undocumented_axioms() {
  local out=""
  local axiom_hits
  axiom_hits="$(scan_rg '^[[:space:]]*axiom\b')"

  if [[ -n "${axiom_hits}" ]]; then
    while IFS= read -r line; do
      # Allow axioms in the dedicated Axioms.lean file
      if [[ ! "${line}" =~ /Axioms\.lean: ]]; then
        out+="${line}"$'\n'
      fi
    done <<< "${axiom_hits}"
  fi

  printf '%s\n' "${out}" | sed '/^$/d' || true
}

print_section "Lean Escape Hatches"

sorry_hits="$(scan_rg '\bsorry\b')"
print_hits "error" "No sorry proofs" "${sorry_hits}" \
  "Replace sorry with complete proofs."

undoc_axiom_hits="$(check_undocumented_axioms)"
print_hits "warning" "Axioms should be in Gibbs/Axioms.lean" "${undoc_axiom_hits}" \
  "Move axioms to Gibbs/Axioms.lean with documentation, or replace with concrete proofs."

print_section "Lean Style-Guide Conformance"

placeholder_hits="$(scan_rg '\bProp\s*:=\s*True\b')"
print_hits "error" "No Prop := True placeholder contracts" "${placeholder_hits}" \
  "Replace placeholder contracts with real predicates/theorems."

# Check facade modules don't import test/example modules
facade_files=(
  "${LEAN_DIR}/Hamiltonian.lean"
  "${LEAN_DIR}/MeanField.lean"
  "${LEAN_DIR}/ContinuumField.lean"
  "${LEAN_DIR}/Consensus.lean"
)
facade_import_hits=""
for facade in "${facade_files[@]}"; do
  if [[ -f "${facade}" ]]; then
    hits="$(rg -n --pcre2 '^(import .*\b(Test|Example|Debug)\b)' "${facade}" 2>/dev/null || true)"
    if [[ -n "${hits}" ]]; then
      facade_import_hits+="${hits}"$'\n'
    fi
  fi
done
facade_import_hits="$(printf '%s' "${facade_import_hits}" | sed '/^$/d' || true)"
print_hits "error" "Facade modules avoid debug/example/test imports" "${facade_import_hits}" \
  "Keep facade imports restricted to production API modules."

long_file_hits="$(collect_file_metric_hits file_length 500)"
print_hits "warning" "Files stay within style-guide length target (<= 500 lines)" "${long_file_hits}" \
  "Split oversized files into coherent submodules with barrel re-exports."

section_header_hits="$(collect_file_metric_hits section_headers 120)"
print_hits "warning" "Non-trivial files include section headers" "${section_header_hits}" \
  "Add /-! ## ... -/ section headers to organize long files."

module_doc_hits="$(collect_file_metric_hits module_doc 120)"
print_hits "warning" "Non-trivial files include module docs" "${module_doc_hits}" \
  "Add a top module doc /-! # ... -/ after imports."

# Check for theorems without docstrings in non-trivial files
theorem_without_doc_hits="$(
  rg -n --pcre2 '^(?!/--)[^\n]*\n^(theorem|lemma)\s+\w+' "${LEAN_DIR}" \
    -g '*.lean' \
    -g '!.lake/**' \
    -g '!**/.lake/**' \
    -U --multiline 2>/dev/null |
  head -30 || true
)"
# Simpler heuristic: find theorem/lemma not preceded by /-- docstring
theorem_nodoc_hits="$(
  rg -B1 -n --pcre2 '^(theorem|lemma)\s+\w+' "${LEAN_DIR}" \
    -g '*.lean' \
    -g '!.lake/**' \
    -g '!**/.lake/**' 2>/dev/null |
  rg -v '/--' |
  rg '(theorem|lemma)\s+\w+' |
  head -30 || true
)"
# This check is informational only - too noisy for now
# print_hits "warning" "Theorems have docstrings" "${theorem_nodoc_hits}" \
#   "Add /-- ... -/ docstrings before theorem declarations."

echo ""
print_section "Summary"

echo "Errors:   ${errors}"
echo "Warnings: ${warnings}"
if (( STRICT == 1 )); then
  echo "Mode:     strict"
else
  echo "Mode:     default"
fi
echo ""
printf "%-8s %-7s %s\n" "Severity" "Count" "Check"
printf "%-8s %-7s %s\n" "--------" "-----" "-----"
printf '%b' "${summary_lines}" | awk -F '\t' '{ printf "%-8s %-7s %s\n", $1, $3, $2 }'
echo ""

if (( errors > 0 )); then
  echo -e "${RED}Lean architecture/style check failed:${NC} ${errors} error(s), ${warnings} warning(s)."
  exit 1
fi

if (( STRICT == 1 && warnings > 0 )); then
  echo -e "${YELLOW}Lean architecture/style check strict-failed:${NC} ${warnings} warning(s)."
  exit 1
fi

if (( warnings > 0 )); then
  echo -e "${YELLOW}Lean architecture/style check passed with warnings:${NC} ${warnings} warning(s)."
else
  echo -e "${GREEN}Lean architecture/style check passed.${NC}"
fi
