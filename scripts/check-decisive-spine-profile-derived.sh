#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveSpineProfile.lean"

echo "[check-decisive-spine-profile-derived] checking profile layer"

for pattern in \
  "decisiveSpine_exact_profile_decomposition" \
  "decisiveSpine_minimizing_sequence_extraction" \
  "decisiveSpine_compactness_mod_symmetry"
do
  if ! rg -n "$pattern" "$FILE" >/dev/null; then
    echo "[check-decisive-spine-profile-derived] FAIL: missing $pattern" >&2
    exit 1
  fi
done

if rg -n "^def decisiveSpine_exact_profile_decomposition_direct\\b|^theorem decisiveSpine_minimizing_sequence_extraction_direct\\b|^theorem decisiveSpine_compactness_mod_symmetry_direct\\b" "$FILE" >/dev/null; then
  echo "[check-decisive-spine-profile-derived] FAIL: retired decisive-spine profile direct wrappers reintroduced" >&2
  rg -n "^def decisiveSpine_exact_profile_decomposition_direct\\b|^theorem decisiveSpine_minimizing_sequence_extraction_direct\\b|^theorem decisiveSpine_compactness_mod_symmetry_direct\\b" "$FILE" >&2
  exit 1
fi

PROFILE_BLOCK="$(
  awk '
    /def decisiveSpine_exact_profile_decomposition$/ {flag=1}
    flag {print}
    flag && /^\/-- Exact minimizing-sequence extraction theorem for decisive spine\./ {exit}
  ' "$FILE"
)"

if [[ -z "$PROFILE_BLOCK" ]]; then
  echo "[check-decisive-spine-profile-derived] FAIL: missing decisiveSpine_exact_profile_decomposition block" >&2
  exit 1
fi

if ! echo "$PROFILE_BLOCK" | rg -n "fullProof_exact_profile_decomposition" >/dev/null; then
  echo "[check-decisive-spine-profile-derived] FAIL: profile decomposition theorem is not routed through fullProof_exact_profile_decomposition" >&2
  echo "$PROFILE_BLOCK" >&2
  exit 1
fi

MIN_BLOCK="$(
  awk '
    /theorem decisiveSpine_minimizing_sequence_extraction$/ {flag=1}
    flag {print}
    flag && /^\/-- Exact compactness-modulo-symmetry extraction theorem for decisive spine\./ {exit}
  ' "$FILE"
)"

if [[ -z "$MIN_BLOCK" ]]; then
  echo "[check-decisive-spine-profile-derived] FAIL: missing decisiveSpine_minimizing_sequence_extraction block" >&2
  exit 1
fi

if ! echo "$MIN_BLOCK" | rg -n "fullProof_exact_minimizing_sequence_extraction" >/dev/null; then
  echo "[check-decisive-spine-profile-derived] FAIL: minimizing-sequence extraction theorem is not routed through fullProof_exact_minimizing_sequence_extraction" >&2
  echo "$MIN_BLOCK" >&2
  exit 1
fi

COMPACT_BLOCK="$(
  awk '
    /theorem decisiveSpine_compactness_mod_symmetry$/ {flag=1}
    flag {print}
    flag && /^\/-- Profile-layer policy marker for decisive spine\./ {exit}
  ' "$FILE"
)"

if [[ -z "$COMPACT_BLOCK" ]]; then
  echo "[check-decisive-spine-profile-derived] FAIL: missing decisiveSpine_compactness_mod_symmetry block" >&2
  exit 1
fi

if ! echo "$COMPACT_BLOCK" | rg -n "fullProof_exact_almostPeriodic_modulus" >/dev/null; then
  echo "[check-decisive-spine-profile-derived] FAIL: compactness-mod-symmetry theorem is not routed through fullProof_exact_almostPeriodic_modulus" >&2
  echo "$COMPACT_BLOCK" >&2
  exit 1
fi

echo "[check-decisive-spine-profile-derived] PASS"
