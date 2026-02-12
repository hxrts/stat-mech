#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveSpineLocalEnergy.lean"

echo "[check-decisive-spine-local-energy-derived] checking local-energy layer"

for pattern in \
  "decisiveSpine_local_energy_inequality" \
  "decisiveSpine_epsilon_regularity" \
  "decisiveSpine_local_energy_compatibility"
do
  if ! rg -n "$pattern" "$FILE" >/dev/null; then
    echo "[check-decisive-spine-local-energy-derived] FAIL: missing $pattern" >&2
    exit 1
  fi
done

echo "[check-decisive-spine-local-energy-derived] PASS"
