#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveSpineMinimalElement.lean"

echo "[check-decisive-spine-minimal-element-derived] checking minimal-element layer"

for pattern in \
  "decisiveSpine_minimal_element_exists" \
  "decisiveSpine_minimal_element_nontrivial" \
  "decisiveSpine_minimal_element_almostPeriodic_modulus"
do
  if ! rg -n "$pattern" "$FILE" >/dev/null; then
    echo "[check-decisive-spine-minimal-element-derived] FAIL: missing $pattern" >&2
    exit 1
  fi
done

if rg -n "^theorem decisiveSpine_minimal_element_exists_direct\\b|^theorem decisiveSpine_minimal_element_nontrivial_direct\\b|^theorem decisiveSpine_minimal_element_almostPeriodic_modulus_direct\\b" "$FILE" >/dev/null; then
  echo "[check-decisive-spine-minimal-element-derived] FAIL: retired decisive-spine minimal-element direct wrappers reintroduced" >&2
  rg -n "^theorem decisiveSpine_minimal_element_exists_direct\\b|^theorem decisiveSpine_minimal_element_nontrivial_direct\\b|^theorem decisiveSpine_minimal_element_almostPeriodic_modulus_direct\\b" "$FILE" >&2
  exit 1
fi

EXISTS_BLOCK="$(
  awk '
    /theorem decisiveSpine_minimal_element_exists$/ {flag=1}
    flag {print}
    flag && /^\/-- Minimal-element nontriviality theorem for decisive spine\./ {exit}
  ' "$FILE"
)"

if [[ -z "$EXISTS_BLOCK" ]]; then
  echo "[check-decisive-spine-minimal-element-derived] FAIL: missing decisiveSpine_minimal_element_exists block" >&2
  exit 1
fi

if ! echo "$EXISTS_BLOCK" | rg -n "fullProof_exact_minimal_element_exists" >/dev/null; then
  echo "[check-decisive-spine-minimal-element-derived] FAIL: minimal-element existence theorem is not routed through fullProof_exact_minimal_element_exists" >&2
  echo "$EXISTS_BLOCK" >&2
  exit 1
fi

NONTRIV_BLOCK="$(
  awk '
    /theorem decisiveSpine_minimal_element_nontrivial$/ {flag=1}
    flag {print}
    flag && /^\/-- Almost-periodicity modulus theorem for decisive spine\./ {exit}
  ' "$FILE"
)"

if [[ -z "$NONTRIV_BLOCK" ]]; then
  echo "[check-decisive-spine-minimal-element-derived] FAIL: missing decisiveSpine_minimal_element_nontrivial block" >&2
  exit 1
fi

if ! echo "$NONTRIV_BLOCK" | rg -n "minimal_element\\.nontrivial_mode" >/dev/null; then
  echo "[check-decisive-spine-minimal-element-derived] FAIL: minimal-element nontriviality theorem is not routed through minimal_element.nontrivial_mode" >&2
  echo "$NONTRIV_BLOCK" >&2
  exit 1
fi

AP_BLOCK="$(
  awk '
    /theorem decisiveSpine_minimal_element_almostPeriodic_modulus$/ {flag=1}
    flag {print}
    flag && /^\/-- Minimal-element layer policy marker for decisive spine\./ {exit}
  ' "$FILE"
)"

if [[ -z "$AP_BLOCK" ]]; then
  echo "[check-decisive-spine-minimal-element-derived] FAIL: missing decisiveSpine_minimal_element_almostPeriodic_modulus block" >&2
  exit 1
fi

if ! echo "$AP_BLOCK" | rg -n "decisiveSpine_compactness_mod_symmetry" >/dev/null; then
  echo "[check-decisive-spine-minimal-element-derived] FAIL: almost-periodicity modulus theorem is not routed through decisiveSpine_compactness_mod_symmetry" >&2
  echo "$AP_BLOCK" >&2
  exit 1
fi

echo "[check-decisive-spine-minimal-element-derived] PASS"
