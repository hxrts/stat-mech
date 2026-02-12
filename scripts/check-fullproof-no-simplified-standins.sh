#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful"

echo "[check-fullproof-no-simplified-standins] scanning full-proof files"

if rg -n --glob 'FullProof*.lean' \
  'periodicCriticalNorm|periodicVelocityControlNorm|clayBDefinitive|unresolvedClayBGlobalClosureLemma|hardStepConstructedGlobalSolution' \
  "$TARGET_DIR" >/dev/null; then
  echo "[check-fullproof-no-simplified-standins] FAIL: found simplified stand-in token in full-proof files" >&2
  exit 1
fi

echo "[check-fullproof-no-simplified-standins] PASS"
