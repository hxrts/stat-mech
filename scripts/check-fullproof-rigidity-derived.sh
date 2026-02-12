#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/FullProofExactRigidity.lean"

echo "[check-fullproof-rigidity-derived] checking rigidity derivation route"

for pattern in \
  "fullProof_exact_localEnergy_epsilonRegularity" \
  "fullProof_exact_lower_upper_quantitative" \
  "fullProof_exact_rigidity_contradiction"
do
  if ! rg -n "$pattern" "$FILE" >/dev/null; then
    echo "[check-fullproof-rigidity-derived] FAIL: missing $pattern" >&2
    exit 1
  fi
done

if rg -n '^import Gibbs\.ContinuumField\.NavierStokes\.HardStep\.Definitive\.' "$FILE" >/dev/null; then
  echo "[check-fullproof-rigidity-derived] FAIL: full-proof rigidity imports definitive hard-step modules" >&2
  exit 1
fi

echo "[check-fullproof-rigidity-derived] PASS"
