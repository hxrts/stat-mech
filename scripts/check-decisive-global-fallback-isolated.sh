#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveGlobal.lean"

echo "[check-decisive-global-fallback-isolated] checking fallback removal"

if [[ ! -f "$FILE" ]]; then
  echo "[check-decisive-global-fallback-isolated] FAIL: missing file $FILE" >&2
  exit 1
fi

CHAIN_BLOCK="$(
  awk '
    /def decisiveGlobalClosureTheorem_from_threshold_minimal_chain/ {flag=1}
    flag {print}
    flag && /\/-! ## Chain generators and data families -\// {exit}
  ' "$FILE"
)"

if [[ -z "$CHAIN_BLOCK" ]]; then
  echo "[check-decisive-global-fallback-isolated] FAIL: missing chain bridge block" >&2
  exit 1
fi

if echo "$CHAIN_BLOCK" | rg -n "L\\.strong|L\\.init_match|L\\.periodicity_preserved" >/dev/null; then
  echo "[check-decisive-global-fallback-isolated] FAIL: chain bridge still contains local-theory constructor bypass" >&2
  echo "$CHAIN_BLOCK" >&2
  exit 1
fi

if rg -n "def decisiveGlobalClosureTheorem_localTheory_fallback" "$FILE" >/dev/null; then
  echo "[check-decisive-global-fallback-isolated] FAIL: fallback theorem definition still present" >&2
  exit 1
fi

CONSTRUCTIVE_BLOCK="$(
  awk '
    /def decisiveGlobalClosureTheorem_constructive/ {flag=1}
    flag {print}
    flag && /^$/ {exit}
  ' "$FILE"
)"

if [[ -z "$CONSTRUCTIVE_BLOCK" ]]; then
  echo "[check-decisive-global-fallback-isolated] FAIL: missing constructive endpoint block" >&2
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
  if ! echo "$CONSTRUCTIVE_BLOCK" | rg -n "$pattern" >/dev/null; then
    echo "[check-decisive-global-fallback-isolated] FAIL: constructive endpoint missing $pattern in no-fallback direct-components->direct-chain route" >&2
    echo "$CONSTRUCTIVE_BLOCK" >&2
    exit 1
  fi
done

if ! echo "$CONSTRUCTIVE_BLOCK" | rg -n "decisiveGlobalClosureTheorem_no_local_fallback_of_chain_generator" >/dev/null; then
  echo "[check-decisive-global-fallback-isolated] FAIL: constructive endpoint is not routed through no-local-fallback chain-generator theorem" >&2
  echo "$CONSTRUCTIVE_BLOCK" >&2
  exit 1
fi

if echo "$CONSTRUCTIVE_BLOCK" | rg -n "decisiveGlobalClosureTheorem_localTheory_fallback|by_cases hchain : Nonempty DecisiveSpineThresholdMinimalFluxChain|L\\.strong|L\\.init_match|L\\.periodicity_preserved" >/dev/null; then
  echo "[check-decisive-global-fallback-isolated] FAIL: constructive endpoint reintroduced fallback/bypass tokens" >&2
  echo "$CONSTRUCTIVE_BLOCK" >&2
  exit 1
fi

if echo "$CONSTRUCTIVE_BLOCK" | rg -n "chain_generator : DecisiveSpineThresholdChainGenerator|decisiveGlobalClosureTheorem_no_local_fallback_of_chain_generator chain_generator" >/dev/null; then
  echo "[check-decisive-global-fallback-isolated] FAIL: constructive endpoint reintroduced chain-generator endpoint surface (expected component-family surface)" >&2
  echo "$CONSTRUCTIVE_BLOCK" >&2
  exit 1
fi

if echo "$CONSTRUCTIVE_BLOCK" | rg -n "witness_family : DecisiveSpineConstructiveWitnessFamily" >/dev/null; then
  echo "[check-decisive-global-fallback-isolated] FAIL: constructive endpoint still exposes witness-family input surface (expected component-family surface)" >&2
  echo "$CONSTRUCTIVE_BLOCK" >&2
  exit 1
fi

if echo "$CONSTRUCTIVE_BLOCK" | rg -n "components : DecisiveSpineConstructiveWitnessComponentFamilies" >/dev/null; then
  echo "[check-decisive-global-fallback-isolated] FAIL: constructive endpoint still exposes component-bundle input surface (expected direct component theorem arguments)" >&2
  echo "$CONSTRUCTIVE_BLOCK" >&2
  exit 1
fi

if echo "$CONSTRUCTIVE_BLOCK" | rg -n "decisiveSpine_constructive_threshold_data|decisiveSpine_constructive_minimizing_data|decisiveSpine_constructive_minimal_element" >/dev/null; then
  echo "[check-decisive-global-fallback-isolated] FAIL: constructive endpoint still uses synthetic canonical threshold/minimizing/minimal data (expected direct theorem arguments)" >&2
  echo "$CONSTRUCTIVE_BLOCK" >&2
  exit 1
fi

if echo "$CONSTRUCTIVE_BLOCK" | rg -n "DecisiveSpineConstructiveEnvelopeComponentFamily|DecisiveSpineConstructiveLowerWitnessComponentFamily|DecisiveSpineConstructiveUpperWitnessComponentFamily" >/dev/null; then
  echo "[check-decisive-global-fallback-isolated] FAIL: constructive endpoint still uses witness/envelope component families (expected direct time/lower-upper hypotheses)" >&2
  echo "$CONSTRUCTIVE_BLOCK" >&2
  exit 1
fi

echo "[check-decisive-global-fallback-isolated] PASS"
