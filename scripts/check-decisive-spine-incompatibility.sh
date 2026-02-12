#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveSpineIncompatibility.lean"

echo "[check-decisive-spine-incompatibility] checking incompatibility layer"

for pattern in \
  "decisiveSpine_crux_incompatibility" \
  "decisiveSpine_incompatibility_theorem" \
  "decisiveSpine_excludes_all_minimal_elements" \
  "DecisiveSpineAstarInfinite" \
  "decisiveSpine_Astar_infinite"
do
  if ! rg -n "$pattern" "$FILE" >/dev/null; then
    echo "[check-decisive-spine-incompatibility] FAIL: missing $pattern" >&2
    exit 1
  fi
done

echo "[check-decisive-spine-incompatibility] PASS"
