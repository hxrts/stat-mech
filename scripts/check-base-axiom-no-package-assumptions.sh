#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomCompletion.lean"

echo "[check-base-axiom-no-package-assumptions] checking endpoint signature in $FILE"

BLOCK="$(rg -n -A8 "theorem clayBStatement_base_axiom_e2e" "$FILE" || true)"
if [[ -z "$BLOCK" ]]; then
  echo "[check-base-axiom-no-package-assumptions] FAIL: endpoint theorem not found" >&2
  exit 1
fi

if echo "$BLOCK" | rg -n "Theorem|Package|Seed" >/dev/null; then
  echo "[check-base-axiom-no-package-assumptions] FAIL: endpoint theorem takes theorem/package/seed assumptions" >&2
  exit 1
fi

if rg -n "DecisiveSeedFromAnalysisTheorem|HardStepGlobalControlTheorem|DecisiveCompletionSeedFamily" "$FILE" >/dev/null; then
  echo "[check-base-axiom-no-package-assumptions] FAIL: legacy theorem-package dependencies found in endpoint file" >&2
  exit 1
fi

for pattern in \
  "clayBStatement_base_axiom_e2e_direct" \
  "clayBStatement_base_axiom_e2e_iff_clayBStatement"
do
  if ! rg -n "$pattern" "$FILE" >/dev/null; then
    echo "[check-base-axiom-no-package-assumptions] FAIL: missing $pattern" >&2
    exit 1
  fi
done

EQUIV_BLOCK="$(rg -n -A4 "theorem clayBStatement_base_axiom_e2e_iff_clayBStatement" "$FILE" || true)"
if echo "$EQUIV_BLOCK" | rg -n "Iff\\.rfl" >/dev/null; then
  echo "[check-base-axiom-no-package-assumptions] FAIL: endpoint equivalence remains definitional aliasing (Iff.rfl)" >&2
  exit 1
fi

echo "[check-base-axiom-no-package-assumptions] PASS"
