#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveSpineProfile.lean"

echo "[check-decisive-spine-profile-derived] checking profile layer"

for pattern in \
  "decisiveSpine_exact_profile_decomposition_direct" \
  "decisiveSpine_exact_profile_decomposition" \
  "decisiveSpine_minimizing_sequence_extraction_direct" \
  "decisiveSpine_minimizing_sequence_extraction" \
  "decisiveSpine_compactness_mod_symmetry_direct" \
  "decisiveSpine_compactness_mod_symmetry"
do
  if ! rg -n "$pattern" "$FILE" >/dev/null; then
    echo "[check-decisive-spine-profile-derived] FAIL: missing $pattern" >&2
    exit 1
  fi
done

echo "[check-decisive-spine-profile-derived] PASS"
