#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveGlobal.lean"

echo "[check-decisive-global-chain-route] checking threshold-chain-based decisive global route"

if [[ ! -f "$FILE" ]]; then
  echo "[check-decisive-global-chain-route] FAIL: missing file $FILE" >&2
  exit 1
fi

THRESHOLD_BLOCK="$(
  awk '
    /def decisiveGlobalClosureTheorem_from_threshold_minimal_chain/ {flag=1}
    flag {print}
    flag && /\/-! ## Chain generators and data families -\// {exit}
  ' "$FILE"
)"

if [[ -z "$THRESHOLD_BLOCK" ]]; then
  echo "[check-decisive-global-chain-route] FAIL: missing threshold-chain theorem block" >&2
  exit 1
fi

for pattern in \
  "decisiveSpine_global_closure_from_threshold_minimal_chain" \
  "decisiveGlobalClosureTheorem_of_hardStepControl" \
  "hardStepGlobalClosure_from_analytic_route"
do
  if ! echo "$THRESHOLD_BLOCK" | rg -n "$pattern" >/dev/null; then
    echo "[check-decisive-global-chain-route] FAIL: threshold-chain theorem block missing $pattern" >&2
    echo "$THRESHOLD_BLOCK" >&2
    exit 1
  fi
done

if echo "$THRESHOLD_BLOCK" | rg -n "L\\.strong|L\\.init_match|L\\.periodicity_preserved" >/dev/null; then
  echo "[check-decisive-global-chain-route] FAIL: found direct local-theory constructor bypass in threshold-chain theorem block" >&2
  echo "$THRESHOLD_BLOCK" >&2
  exit 1
fi

echo "[check-decisive-global-chain-route] PASS"
