#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GLOBAL_FILE="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveGlobal.lean"
COMP_FILE="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveCompletion.lean"
SEED_FILE="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/SeedConstruction.lean"

echo "[check-final-no-witness-inputs] checking decisive constructive endpoint inputs"

for f in "$COMP_FILE" "$SEED_FILE"; do
  if [[ ! -f "$f" ]]; then
    echo "[check-final-no-witness-inputs] FAIL: missing file $f" >&2
    exit 1
  fi
  if rg -n '\([^)]*:\s*DecisiveSpine(Lower|Upper)WitnessFamily\b' "$f" >/dev/null; then
    echo "[check-final-no-witness-inputs] FAIL: found witness-family input in $f" >&2
    rg -n '\([^)]*:\s*DecisiveSpine(Lower|Upper)WitnessFamily\b' "$f" >&2
    exit 1
  fi
done

if [[ ! -f "$GLOBAL_FILE" ]]; then
  echo "[check-final-no-witness-inputs] FAIL: missing file $GLOBAL_FILE" >&2
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
  echo "[check-final-no-witness-inputs] FAIL: missing decisiveGlobalClosureTheorem_constructive block" >&2
  exit 1
fi
if echo "$BLOCK" | rg -n 'DecisiveSpine(Lower|Upper)WitnessFamily' >/dev/null; then
  echo "[check-final-no-witness-inputs] FAIL: decisiveGlobalClosureTheorem_constructive still takes witness-family inputs" >&2
  echo "$BLOCK" >&2
  exit 1
fi

echo "[check-final-no-witness-inputs] PASS"
