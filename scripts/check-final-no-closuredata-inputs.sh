#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILES=(
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveGlobal.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveCompletion.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/SeedConstruction.lean"
)

echo "[check-final-no-closuredata-inputs] checking decisive constructive-route files"

for f in "${FILES[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "[check-final-no-closuredata-inputs] FAIL: missing file $f" >&2
    exit 1
  fi

  if rg -n '\([^)]*:\s*DecisiveSpineClosureData\b|\bclosure_data\b' "$f" >/dev/null; then
    echo "[check-final-no-closuredata-inputs] FAIL: found closure-data carrier input/token in $f" >&2
    rg -n '\([^)]*:\s*DecisiveSpineClosureData\b|\bclosure_data\b' "$f" >&2
    exit 1
  fi
done

echo "[check-final-no-closuredata-inputs] PASS"
