#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

TARGETS=(
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomCompletion.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/Final.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveGlobal.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveCompletion.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/SeedConstruction.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/ClassicalEquivalence.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/HardStep/ContradictionClosure.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/HardStep/Definitive/GlobalClosure.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/HardStep/Definitive/ClayB.lean"
)

echo "[check-navier-final-no-trivial-smoothness] checking endpoint theorem route files"

for f in "${TARGETS[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "[check-navier-final-no-trivial-smoothness] FAIL: missing file $f" >&2
    exit 1
  fi
done

if rg -n 'smoothVelocity\s*:=\s*fun _ => True|smoothPressure\s*:=\s*fun _ => True' "${TARGETS[@]}" >/dev/null; then
  echo "[check-navier-final-no-trivial-smoothness] FAIL: found trivial smoothness assignment in endpoint route files" >&2
  rg -n 'smoothVelocity\s*:=\s*fun _ => True|smoothPressure\s*:=\s*fun _ => True' "${TARGETS[@]}" >&2
  exit 1
fi

echo "[check-navier-final-no-trivial-smoothness] PASS"
