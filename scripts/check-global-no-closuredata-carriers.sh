#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILES=(
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/BaseAxiomGlobal.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/FullProofExactGlobal.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveSpineGlobal.lean"
)

echo "[check-global-no-closuredata-carriers] checking global-route files"

for f in "${FILES[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "[check-global-no-closuredata-carriers] FAIL: missing file $f" >&2
    exit 1
  fi

  if rg -n '\b(ClosureData|closure_data)\b' "$f" >/dev/null; then
    echo "[check-global-no-closuredata-carriers] FAIL: found closure-data carrier token in $f" >&2
    rg -n '\b(ClosureData|closure_data)\b' "$f" >&2
    exit 1
  fi
done

echo "[check-global-no-closuredata-carriers] PASS"
