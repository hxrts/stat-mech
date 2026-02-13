#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GLOBAL_FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveGlobal.lean"
COMP_FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveCompletion.lean"
SEED_FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/SeedConstruction.lean"

echo "[check-final-no-threshold-chain-inputs] checking constructive endpoint signatures"

for f in "$COMP_FILE" "$SEED_FILE"; do
  if [[ ! -f "$f" ]]; then
    echo "[check-final-no-threshold-chain-inputs] FAIL: missing file $f" >&2
    exit 1
  fi
  if rg -n '\([^)]*:\s*DecisiveSpineThresholdMinimalFluxChain\b' "$f" >/dev/null; then
    echo "[check-final-no-threshold-chain-inputs] FAIL: found threshold/minimal chain input in $f" >&2
    rg -n '\([^)]*:\s*DecisiveSpineThresholdMinimalFluxChain\b' "$f" >&2
    exit 1
  fi
done

if [[ ! -f "$GLOBAL_FILE" ]]; then
  echo "[check-final-no-threshold-chain-inputs] FAIL: missing file $GLOBAL_FILE" >&2
  exit 1
fi

BLOCK="$(
  awk '
    /def decisiveGlobalClosureTheorem_constructive/ {flag=1}
    flag {print}
    flag && /:= by/ {exit}
  ' "$GLOBAL_FILE"
)"
if [[ -z "$BLOCK" ]]; then
  echo "[check-final-no-threshold-chain-inputs] FAIL: missing decisiveGlobalClosureTheorem_constructive block" >&2
  exit 1
fi
if echo "$BLOCK" | rg -n 'DecisiveSpineThresholdMinimalFluxChain' >/dev/null; then
  echo "[check-final-no-threshold-chain-inputs] FAIL: decisiveGlobalClosureTheorem_constructive still takes threshold/minimal chain input" >&2
  echo "$BLOCK" >&2
  exit 1
fi

echo "[check-final-no-threshold-chain-inputs] PASS"
