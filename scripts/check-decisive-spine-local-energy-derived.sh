#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveSpineLocalEnergy.lean"

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

BLOCK="$(
  awk '
    /theorem decisiveSpine_local_energy_inequality$/ {flag=1}
    flag {print}
    flag && /^\/-- Exact epsilon-regularity theorem for decisive spine\./ {exit}
  ' "$FILE"
)"

if [[ -z "$BLOCK" ]]; then
  echo "[check-decisive-spine-local-energy-derived] FAIL: missing decisiveSpine_local_energy_inequality block" >&2
  exit 1
fi

if ! echo "$BLOCK" | rg -n "baseAxiom_local_energy_epsilon_regularity" >/dev/null; then
  echo "[check-decisive-spine-local-energy-derived] FAIL: local-energy inequality theorem is not routed through baseAxiom_local_energy_epsilon_regularity" >&2
  echo "$BLOCK" >&2
  exit 1
fi

if echo "$BLOCK" | rg -n "baseAxiom_local_energy_epsilon_regularity_direct|decisiveSpine_local_energy_inequality_direct" >/dev/null; then
  echo "[check-decisive-spine-local-energy-derived] FAIL: local-energy inequality theorem still uses retired direct wrappers" >&2
  echo "$BLOCK" >&2
  exit 1
fi

if rg -n "^theorem decisiveSpine_local_energy_inequality_direct\\b|^theorem decisiveSpine_epsilon_regularity_direct\\b" "$FILE" >/dev/null; then
  echo "[check-decisive-spine-local-energy-derived] FAIL: retired decisive-spine local-energy direct wrappers reintroduced" >&2
  rg -n "^theorem decisiveSpine_local_energy_inequality_direct\\b|^theorem decisiveSpine_epsilon_regularity_direct\\b" "$FILE" >&2
  exit 1
fi

echo "[check-decisive-spine-local-energy-derived] PASS"
