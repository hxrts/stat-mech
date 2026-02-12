#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful"

echo "[check-base-axiom-no-definitive-shortcuts] scanning base-axiom files"

FILES=(
  "$TARGET_DIR/BaseAxiomAnalysis.lean"
  "$TARGET_DIR/BaseAxiomLocalTheory.lean"
  "$TARGET_DIR/BaseAxiomCompactness.lean"
  "$TARGET_DIR/BaseAxiomRigidity.lean"
  "$TARGET_DIR/BaseAxiomGlobal.lean"
  "$TARGET_DIR/BaseAxiomCompletion.lean"
)

for f in "${FILES[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "[check-base-axiom-no-definitive-shortcuts] FAIL: missing file $f" >&2
    exit 1
  fi

  if rg -n 'clayBDefinitive|unresolvedClayBGlobalClosureLemma|hardStepConstructedGlobalSolution|clayBRegularityData_of_any_hypotheses' "$f" >/dev/null; then
    echo "[check-base-axiom-no-definitive-shortcuts] FAIL: found definitive shortcut token in $f" >&2
    exit 1
  fi
done

echo "[check-base-axiom-no-definitive-shortcuts] PASS"
