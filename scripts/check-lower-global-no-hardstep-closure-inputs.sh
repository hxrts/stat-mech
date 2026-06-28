#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILES=(
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/BaseAxiomGlobal.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/FullProofExactGlobal.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveSpineGlobal.lean"
)

echo "[check-lower-global-no-hardstep-closure-inputs] checking lower global-route files"

for f in "${FILES[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "[check-lower-global-no-hardstep-closure-inputs] FAIL: missing file $f" >&2
    exit 1
  fi

  if rg -n '\([^)]*:\s*HardStepGlobalClosure\)' "$f" >/dev/null; then
    echo "[check-lower-global-no-hardstep-closure-inputs] FAIL: found direct HardStepGlobalClosure input in $f" >&2
    rg -n '\([^)]*:\s*HardStepGlobalClosure\)' "$f" >&2
    exit 1
  fi
done

echo "[check-lower-global-no-hardstep-closure-inputs] PASS"
