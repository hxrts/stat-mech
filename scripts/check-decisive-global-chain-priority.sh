#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveGlobal.lean"

echo "[check-decisive-global-chain-priority] checking constructive endpoint no-fallback route"

if [[ ! -f "$FILE" ]]; then
  echo "[check-decisive-global-chain-priority] FAIL: missing file $FILE" >&2
  exit 1
fi

BLOCK="$(
  awk '
    /def decisiveGlobalClosureTheorem_constructive/ {flag=1}
    flag {print}
    flag && /^$/ {exit}
  ' "$FILE"
)"

if [[ -z "$BLOCK" ]]; then
  echo "[check-decisive-global-chain-priority] FAIL: missing constructive theorem block" >&2
  exit 1
fi

for pattern in \
  "threshold_of : DecisiveSpineConstructiveThresholdComponentFamily" \
  "minimizing_of : DecisiveSpineConstructiveMinimizingComponentFamily threshold_of" \
  "minimal_element_of : DecisiveSpineConstructiveMinimalElementComponentFamily" \
  "U_of : DecisiveSpineConstructiveTrajectoryComponentFamily" \
  "t0_of : DecisiveSpineConstructiveTimeComponentFamily U_of" \
  "lower_hypotheses_of :" \
  "DecisiveSpineConstructiveLowerFluxHypothesisComponentFamily U_of t0_of" \
  "upper_hypotheses_of :" \
  "DecisiveSpineConstructiveUpperFluxHypothesisComponentFamily U_of t0_of" \
  "decisiveSpine_threshold_chain_generator_of_direct_constructive_components" \
  "decisiveGlobalClosureTheorem_no_local_fallback_of_chain_generator"
do
  if ! echo "$BLOCK" | rg -n "$pattern" >/dev/null; then
    echo "[check-decisive-global-chain-priority] FAIL: constructive theorem block missing $pattern" >&2
    echo "$BLOCK" >&2
    exit 1
  fi
done

if echo "$BLOCK" | rg -n "by_cases hchain : Nonempty DecisiveSpineThresholdMinimalFluxChain|decisiveGlobalClosureTheorem_localTheory_fallback" >/dev/null; then
  echo "[check-decisive-global-chain-priority] FAIL: constructive theorem still contains fallback/by_cases branching tokens" >&2
  echo "$BLOCK" >&2
  exit 1
fi

if echo "$BLOCK" | rg -n "chain_generator : DecisiveSpineThresholdChainGenerator|decisiveGlobalClosureTheorem_no_local_fallback_of_chain_generator chain_generator" >/dev/null; then
  echo "[check-decisive-global-chain-priority] FAIL: constructive theorem still exposes chain-generator input surface (expected component-family surface)" >&2
  echo "$BLOCK" >&2
  exit 1
fi

if echo "$BLOCK" | rg -n "witness_family : DecisiveSpineConstructiveWitnessFamily" >/dev/null; then
  echo "[check-decisive-global-chain-priority] FAIL: constructive theorem still exposes witness-family input surface (expected component-family surface)" >&2
  echo "$BLOCK" >&2
  exit 1
fi

if echo "$BLOCK" | rg -n "components : DecisiveSpineConstructiveWitnessComponentFamilies" >/dev/null; then
  echo "[check-decisive-global-chain-priority] FAIL: constructive theorem still exposes component-bundle input surface (expected direct component theorem arguments)" >&2
  echo "$BLOCK" >&2
  exit 1
fi

if echo "$BLOCK" | rg -n "decisiveSpine_constructive_threshold_data|decisiveSpine_constructive_minimizing_data|decisiveSpine_constructive_minimal_element" >/dev/null; then
  echo "[check-decisive-global-chain-priority] FAIL: constructive theorem still uses synthetic canonical threshold/minimizing/minimal data (expected direct theorem arguments)" >&2
  echo "$BLOCK" >&2
  exit 1
fi

if echo "$BLOCK" | rg -n "DecisiveSpineConstructiveEnvelopeComponentFamily|DecisiveSpineConstructiveLowerWitnessComponentFamily|DecisiveSpineConstructiveUpperWitnessComponentFamily" >/dev/null; then
  echo "[check-decisive-global-chain-priority] FAIL: constructive theorem still uses witness/envelope component families (expected direct time/lower-upper hypotheses)" >&2
  echo "$BLOCK" >&2
  exit 1
fi

if echo "$BLOCK" | rg -n "L\\.strong|L\\.init_match|L\\.periodicity_preserved" >/dev/null; then
  echo "[check-decisive-global-chain-priority] FAIL: constructive theorem reintroduced local-theory constructor bypass" >&2
  echo "$BLOCK" >&2
  exit 1
fi

echo "[check-decisive-global-chain-priority] PASS"
