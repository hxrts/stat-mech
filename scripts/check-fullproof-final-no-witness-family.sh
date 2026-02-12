#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/FullProofClayFinalization.lean"

echo "[check-fullproof-final-no-witness-family] checking finalization endpoint aliases"

if rg -n "FullProofEndpointWitnessFamily" "$FILE" >/dev/null; then
  echo "[check-fullproof-final-no-witness-family] FAIL: FullProofEndpointWitnessFamily should not appear in finalization" >&2
  rg -n "FullProofEndpointWitnessFamily" "$FILE" >&2
  exit 1
fi

echo "[check-fullproof-final-no-witness-family] PASS"
