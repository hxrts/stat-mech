#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/SeedConstruction.lean"

echo "[check-decisive-no-seed-family] checking endpoint signature in $FILE"

BLOCK="$(rg -n -A8 "theorem clayBStatement_from_decisive_completion_no_nonempty" "$FILE" || true)"
if [[ -z "$BLOCK" ]]; then
  echo "[check-decisive-no-seed-family] FAIL: endpoint theorem not found" >&2
  exit 1
fi

if echo "$BLOCK" | rg -n "DecisiveCompletionSeedFamily|Nonempty" >/dev/null; then
  echo "[check-decisive-no-seed-family] FAIL: endpoint still depends on Nonempty seed-family assumptions" >&2
  exit 1
fi

echo "[check-decisive-no-seed-family] PASS"
