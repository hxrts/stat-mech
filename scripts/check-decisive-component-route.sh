#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DG="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveGlobal.lean"
DC="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveCompletion.lean"
SC="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/SeedConstruction.lean"

echo "[check-decisive-component-route] checking direct-component constructive route"

extract_block() {
  local start="$1"
  local file="$2"
  awk -v s="$start" '
    $0 ~ s {flag=1}
    flag {print}
    flag && /^$/ {exit}
  ' "$file"
}

DG_PRIMARY="$(extract_block '^def decisiveGlobalClosureTheorem_constructive' "$DG")"
if [[ -z "$DG_PRIMARY" ]]; then
  echo "[check-decisive-component-route] FAIL: missing primary constructive endpoint block in DecisiveGlobal" >&2
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
  "decisiveSpine_threshold_chain_generator_of_direct_constructive_components"
do
  if ! echo "$DG_PRIMARY" | rg -n "$pattern" >/dev/null; then
    echo "[check-decisive-component-route] FAIL: DecisiveGlobal primary endpoint missing $pattern" >&2
    echo "$DG_PRIMARY" >&2
    exit 1
  fi
done
if echo "$DG_PRIMARY" | rg -n "decisiveSpine_constructive_threshold_data|decisiveSpine_constructive_minimizing_data|decisiveSpine_constructive_minimal_element|witness_family : DecisiveSpineConstructiveWitnessFamily" >/dev/null; then
  echo "[check-decisive-component-route] FAIL: DecisiveGlobal primary endpoint uses canonical or witness-family inputs" >&2
  echo "$DG_PRIMARY" >&2
  exit 1
fi
if echo "$DG_PRIMARY" | rg -n "DecisiveSpineConstructiveEnvelopeComponentFamily|DecisiveSpineConstructiveLowerWitnessComponentFamily|DecisiveSpineConstructiveUpperWitnessComponentFamily" >/dev/null; then
  echo "[check-decisive-component-route] FAIL: DecisiveGlobal primary endpoint still exposes witness/envelope component families" >&2
  echo "$DG_PRIMARY" >&2
  exit 1
fi

if rg -n "DecisiveSpineConstructiveWitnessComponentFamilies|DecisiveSpineConstructiveWitnessFamily|decisiveSpine_constructive_witness_component_families\\b|decisiveSpine_constructive_witness_family_of_component_families\\b|decisiveSpine_constructive_witness_component_families_of_witness_family\\b|decisiveSpine_constructive_flux_hypotheses_of_witness_family\\b|decisiveGlobalClosureTheorem_constructive_of_witness_hypotheses\\b" "$DG" >/dev/null; then
  echo "[check-decisive-component-route] FAIL: retired witness-family/component-bundle symbols reintroduced in DecisiveGlobal" >&2
  rg -n "DecisiveSpineConstructiveWitnessComponentFamilies|DecisiveSpineConstructiveWitnessFamily|decisiveSpine_constructive_witness_component_families\\b|decisiveSpine_constructive_witness_family_of_component_families\\b|decisiveSpine_constructive_witness_component_families_of_witness_family\\b|decisiveSpine_constructive_flux_hypotheses_of_witness_family\\b|decisiveGlobalClosureTheorem_constructive_of_witness_hypotheses\\b" "$DG" >&2
  exit 1
fi

if rg -n "DecisiveSpineConstructiveFluxHypothesesFamily|decisiveSpine_threshold_chain_generator_of_constructive_flux_hypotheses\\b|decisiveGlobalClosureTheorem_constructive_of_flux_hypotheses\\b|decisiveSpine_constructive_threshold_data\\b|decisiveSpine_constructive_minimizing_data\\b|decisiveSpine_constructive_minimal_element\\b|decisiveSpine_threshold_chain_generator_constructive\\b|decisiveSpine_threshold_chain_data_family_of_component_families\\b" "$DG" >/dev/null; then
  echo "[check-decisive-component-route] FAIL: retired synthetic flux/canonical branch symbols reintroduced in DecisiveGlobal" >&2
  rg -n "DecisiveSpineConstructiveFluxHypothesesFamily|decisiveSpine_threshold_chain_generator_of_constructive_flux_hypotheses\\b|decisiveGlobalClosureTheorem_constructive_of_flux_hypotheses\\b|decisiveSpine_constructive_threshold_data\\b|decisiveSpine_constructive_minimizing_data\\b|decisiveSpine_constructive_minimal_element\\b|decisiveSpine_threshold_chain_generator_constructive\\b|decisiveSpine_threshold_chain_data_family_of_component_families\\b" "$DG" >&2
  exit 1
fi

if rg -n "decisiveGlobalClosureTheorem_constructive_of_component_families\\b" "$DG" >/dev/null; then
  echo "[check-decisive-component-route] FAIL: retired constructive compatibility alias reintroduced in DecisiveGlobal" >&2
  rg -n "decisiveGlobalClosureTheorem_constructive_of_component_families\\b" "$DG" >&2
  exit 1
fi

DC_PRIMARY="$(extract_block '^theorem clayBStatement_from_decisive_completion_constructive' "$DC")"
if [[ -z "$DC_PRIMARY" ]]; then
  echo "[check-decisive-component-route] FAIL: missing primary decisive-completion constructive endpoint" >&2
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
  "decisiveGlobalClosureTheorem_constructive" \
  "threshold_of minimizing_of minimal_element_of" \
  "U_of t0_of" \
  "lower_hypotheses_of upper_hypotheses_of"
do
  if ! echo "$DC_PRIMARY" | rg -n "$pattern" >/dev/null; then
    echo "[check-decisive-component-route] FAIL: decisive-completion primary endpoint missing $pattern" >&2
    echo "$DC_PRIMARY" >&2
    exit 1
  fi
done
if echo "$DC_PRIMARY" | rg -n "decisiveSpine_constructive_threshold_data|decisiveSpine_constructive_minimizing_data|decisiveSpine_constructive_minimal_element" >/dev/null; then
  echo "[check-decisive-component-route] FAIL: decisive-completion primary endpoint still uses canonical data" >&2
  echo "$DC_PRIMARY" >&2
  exit 1
fi
if echo "$DC_PRIMARY" | rg -n "DecisiveSpineConstructiveEnvelopeComponentFamily|DecisiveSpineConstructiveLowerWitnessComponentFamily|DecisiveSpineConstructiveUpperWitnessComponentFamily" >/dev/null; then
  echo "[check-decisive-component-route] FAIL: decisive-completion primary endpoint still uses witness/envelope component families" >&2
  echo "$DC_PRIMARY" >&2
  exit 1
fi

if rg -n "clayBStatement_from_decisive_completion_constructive_of_component_families\\b" "$DC" >/dev/null; then
  echo "[check-decisive-component-route] FAIL: retired constructive compatibility alias reintroduced in DecisiveCompletion" >&2
  rg -n "clayBStatement_from_decisive_completion_constructive_of_component_families\\b" "$DC" >&2
  exit 1
fi

SC_PRIMARY="$(extract_block '^theorem clayBStatement_from_constructive_global_closure_and_seed_construction' "$SC")"
if [[ -z "$SC_PRIMARY" ]]; then
  echo "[check-decisive-component-route] FAIL: missing primary seed-construction constructive endpoint" >&2
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
  "decisiveGlobalClosureTheorem_constructive" \
  "threshold_of minimizing_of minimal_element_of" \
  "U_of t0_of" \
  "lower_hypotheses_of upper_hypotheses_of"
do
  if ! echo "$SC_PRIMARY" | rg -n "$pattern" >/dev/null; then
    echo "[check-decisive-component-route] FAIL: seed-construction primary endpoint missing $pattern" >&2
    echo "$SC_PRIMARY" >&2
    exit 1
  fi
done
if echo "$SC_PRIMARY" | rg -n "decisiveSpine_constructive_threshold_data|decisiveSpine_constructive_minimizing_data|decisiveSpine_constructive_minimal_element" >/dev/null; then
  echo "[check-decisive-component-route] FAIL: seed-construction primary endpoint still uses canonical data" >&2
  echo "$SC_PRIMARY" >&2
  exit 1
fi
if echo "$SC_PRIMARY" | rg -n "DecisiveSpineConstructiveEnvelopeComponentFamily|DecisiveSpineConstructiveLowerWitnessComponentFamily|DecisiveSpineConstructiveUpperWitnessComponentFamily" >/dev/null; then
  echo "[check-decisive-component-route] FAIL: seed-construction primary endpoint still uses witness/envelope component families" >&2
  echo "$SC_PRIMARY" >&2
  exit 1
fi

if rg -n "clayBStatement_from_constructive_global_closure_and_seed_construction_of_component_families\\b" "$SC" >/dev/null; then
  echo "[check-decisive-component-route] FAIL: retired constructive compatibility alias reintroduced in SeedConstruction" >&2
  rg -n "clayBStatement_from_constructive_global_closure_and_seed_construction_of_component_families\\b" "$SC" >&2
  exit 1
fi

echo "[check-decisive-component-route] PASS"
