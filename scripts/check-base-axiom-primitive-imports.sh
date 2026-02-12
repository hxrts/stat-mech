#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILES=(
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomAnalysis.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomLocalTheory.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomCompactness.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomRigidity.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomGlobal.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomCompletion.lean"
)

echo "[check-base-axiom-primitive-imports] checking base-axiom module imports"

for f in "${FILES[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "[check-base-axiom-primitive-imports] FAIL: missing file $f" >&2
    exit 1
  fi

  if ! rg -n '^import ' "$f" >/dev/null; then
    echo "[check-base-axiom-primitive-imports] FAIL: no imports in $f" >&2
    exit 1
  fi

  if rg -n 'Faithful\.(DecisiveCompletion|SeedConstruction|ClassicalEquivalence|DecisiveGlobal|TrueHardStep)' "$f" >/dev/null; then
    echo "[check-base-axiom-primitive-imports] FAIL: disallowed endpoint import in $f" >&2
    exit 1
  fi

done

echo "[check-base-axiom-primitive-imports] PASS"
