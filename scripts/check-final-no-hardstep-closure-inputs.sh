#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILES=(
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveGlobal.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveCompletion.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/SeedConstruction.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/ClassicalEquivalence.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/Final.lean"
)

echo "[check-final-no-hardstep-closure-inputs] checking endpoint files"

for f in "${FILES[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "[check-final-no-hardstep-closure-inputs] FAIL: missing file $f" >&2
    exit 1
  fi

  if rg -n '\([^)]*:\s*HardStepGlobalClosure\)' "$f" >/dev/null; then
    echo "[check-final-no-hardstep-closure-inputs] FAIL: found direct HardStepGlobalClosure input in $f" >&2
    rg -n '\([^)]*:\s*HardStepGlobalClosure\)' "$f" >&2
    exit 1
  fi
done

echo "[check-final-no-hardstep-closure-inputs] PASS"
