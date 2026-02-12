#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/FullProofExactCompactness.lean"

echo "[check-fullproof-compactness-derived] checking compactness derivation route"

for pattern in \
  "fullProof_exact_profile_decomposition" \
  "fullProof_exact_Astar_properties" \
  "fullProof_exact_minimizing_sequence_extraction" \
  "fullProof_exact_minimal_element_exists" \
  "fullProof_exact_almostPeriodic_modulus"
do
  if ! rg -n "$pattern" "$FILE" >/dev/null; then
    echo "[check-fullproof-compactness-derived] FAIL: missing $pattern" >&2
    exit 1
  fi
done

if rg -n '^import Gibbs\.ContinuumField\.NavierStokes\.HardStep\.Definitive\.' "$FILE" >/dev/null; then
  echo "[check-fullproof-compactness-derived] FAIL: full-proof compactness imports definitive hard-step modules" >&2
  exit 1
fi

echo "[check-fullproof-compactness-derived] PASS"
