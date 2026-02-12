#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveSpineMinimalElement.lean"

echo "[check-decisive-spine-minimal-element-derived] checking minimal-element layer"

for pattern in \
  "decisiveSpine_minimal_element_exists_direct" \
  "decisiveSpine_minimal_element_exists" \
  "decisiveSpine_minimal_element_nontrivial_direct" \
  "decisiveSpine_minimal_element_nontrivial" \
  "decisiveSpine_minimal_element_almostPeriodic_modulus_direct" \
  "decisiveSpine_minimal_element_almostPeriodic_modulus"
do
  if ! rg -n "$pattern" "$FILE" >/dev/null; then
    echo "[check-decisive-spine-minimal-element-derived] FAIL: missing $pattern" >&2
    exit 1
  fi
done

echo "[check-decisive-spine-minimal-element-derived] PASS"
