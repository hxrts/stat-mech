#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
allowlist_file="$repo_root/work/navier_placeholder_allowlist.txt"

if [[ ! -f "$allowlist_file" ]]; then
  echo "missing allowlist: $allowlist_file" >&2
  exit 1
fi

cone_file_list="$(mktemp)"
trap 'rm -f "$cone_file_list"' EXIT

{
  find "$repo_root/StatMech/ContinuumField/NavierStokes/HardStep" -type f -name '*.lean'
  printf '%s\n' "$repo_root/StatMech/ContinuumField/NavierStokes/Global/ClayEndgame.lean"
  printf '%s\n' "$repo_root/StatMech/ContinuumField/NavierStokes/Global/ClayPeriodic.lean"
} | sort > "$cone_file_list"

if [[ ! -s "$cone_file_list" ]]; then
  echo "no cone files found" >&2
  exit 1
fi

# Extract declaration names and keep only placeholder-like names.
decls="$(
  xargs rg --no-filename -N "^(def|theorem|structure|abbrev|inductive|class) " < "$cone_file_list" \
    | sed -E 's/^(def|theorem|structure|abbrev|inductive|class) ([A-Za-z0-9_]+).*/\2/' \
    | rg "(Witness|Package|Unresolved|Placeholder)" \
    | sort -u || true
)"

allowed="$(
  grep -Ev '^\s*(#|$)' "$allowlist_file" | sort -u
)"

unknown="$(
  comm -23 \
    <(printf '%s\n' "$decls" | sed '/^$/d' | sort -u) \
    <(printf '%s\n' "$allowed" | sed '/^$/d' | sort -u) || true
)"

if [[ -n "$unknown" ]]; then
  echo "new placeholder-style declarations found in final Clay(B) cone:" >&2
  printf '%s\n' "$unknown" >&2
  echo >&2
  echo "add only if intentional: work/navier_placeholder_allowlist.txt" >&2
  exit 1
fi

echo "navier placeholder cone check: PASS"
