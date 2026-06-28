#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
COMP_FILE="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveCompletion.lean"
SEED_FILE="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/SeedConstruction.lean"

echo "[check-decisive-completion-seedwise-no-fallback] checking seedwise no-fallback route"

for f in "$COMP_FILE" "$SEED_FILE"; do
  if [[ ! -f "$f" ]]; then
    echo "[check-decisive-completion-seedwise-no-fallback] FAIL: missing file $f" >&2
    exit 1
  fi
done

for pattern in \
  "DecisiveSeedwiseGlobalClosure" \
  "faithfulPipelineExists_from_seedwise_decisive_global_closure" \
  "clayBStatement_from_seedwise_decisive_completion" \
  "DecisiveSeedwiseThresholdChainOnSeeds" \
  "DecisiveSeedwiseThresholdChainDataOnSeeds" \
  "decisiveSeedwise_threshold_chain_on_seeds_of_chain_generator" \
  "decisiveSeedwise_threshold_chain_data_on_seeds_of_data_family" \
  "decisiveSeedwise_global_closure_no_local_fallback_of_chain_on_seeds" \
  "clayBStatement_from_decisive_completion_no_local_fallback_seedwise" \
  "clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_chain_generator" \
  "clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_data_on_seeds" \
  "clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_data_family" \
  "clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_global_direct_component_families"
do
  if ! rg -n "$pattern" "$COMP_FILE" >/dev/null; then
    echo "[check-decisive-completion-seedwise-no-fallback] FAIL: missing $pattern in $COMP_FILE" >&2
    exit 1
  fi
done

for legacy in \
  "theorem clayBStatement_from_decisive_completion_no_local_fallback\\b" \
  "theorem clayBStatement_from_decisive_completion_no_local_fallback_of_data_family\\b" \
  "theorem clayBStatement_from_decisive_completion_no_local_fallback_of_component_families\\b" \
  "theorem clayBStatement_from_decisive_completion_no_local_fallback_seedwise_via_component_families\\b" \
  "theorem decisiveSeedwise_component_families_of_chain_on_seeds\\b" \
  "theorem decisiveSeedwise_threshold_chain_data_on_seeds_of_component_families\\b" \
  "theorem clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_component_families\\b"
do
  if rg -n "$legacy" "$COMP_FILE" >/dev/null; then
    echo "[check-decisive-completion-seedwise-no-fallback] FAIL: legacy non-seedwise no-fallback endpoint reintroduced in $COMP_FILE: $legacy" >&2
    exit 1
  fi
done

if rg -n "theorem clayBStatement_from_no_local_fallback_global_closure_and_seed_construction\\b" "$SEED_FILE" >/dev/null; then
  echo "[check-decisive-completion-seedwise-no-fallback] FAIL: legacy seed-construction alias reintroduced in $SEED_FILE: theorem clayBStatement_from_no_local_fallback_global_closure_and_seed_construction" >&2
  exit 1
fi

BLOCK="$(
  awk '
    /theorem decisiveSeedwise_global_closure_no_local_fallback_of_chain_on_seeds/ {flag=1}
    flag {print}
    flag && /\/-- Seedwise no-local-fallback closure on chosen seed triples from explicit seedwise data\./ {exit}
  ' "$COMP_FILE"
)"

if [[ -z "$BLOCK" ]]; then
  echo "[check-decisive-completion-seedwise-no-fallback] FAIL: missing seedwise no-fallback closure theorem block" >&2
  exit 1
fi

for pattern in \
  "decisiveGlobalClosureTheorem_from_threshold_minimal_chain"
do
  if ! echo "$BLOCK" | rg -n "$pattern" >/dev/null; then
    echo "[check-decisive-completion-seedwise-no-fallback] FAIL: seedwise no-fallback closure block missing $pattern" >&2
    echo "$BLOCK" >&2
    exit 1
  fi
done

if echo "$BLOCK" | rg -n "decisiveGlobalClosureTheorem_localTheory_fallback" >/dev/null; then
  echo "[check-decisive-completion-seedwise-no-fallback] FAIL: seedwise no-fallback closure block references local fallback" >&2
  echo "$BLOCK" >&2
  exit 1
fi

for pattern in \
  "clayBStatement_from_no_local_fallback_seedwise_chain_generator_and_seed_construction" \
  "clayBStatement_from_no_local_fallback_seedwise_chain_on_seeds_and_seed_construction" \
  "clayBStatement_from_no_local_fallback_seedwise_data_on_seeds_and_seed_construction" \
  "clayBStatement_from_no_local_fallback_seedwise_component_families_and_seed_construction" \
  "clayBStatement_from_no_local_fallback_component_families_and_seed_construction"
do
  if ! rg -n "$pattern" "$SEED_FILE" >/dev/null; then
    echo "[check-decisive-completion-seedwise-no-fallback] FAIL: missing $pattern in $SEED_FILE" >&2
    exit 1
  fi
done

SEED_CHAIN_BLOCK="$(
  awk '
    /theorem clayBStatement_from_no_local_fallback_seedwise_chain_generator_and_seed_construction/ {flag=1}
    flag {print}
    flag && /\/-- Final endpoint route from seedwise chain nonemptiness on chosen seed triples\./ {exit}
  ' "$SEED_FILE"
)"

if [[ -z "$SEED_CHAIN_BLOCK" ]]; then
  echo "[check-decisive-completion-seedwise-no-fallback] FAIL: missing seedwise chain-generator endpoint theorem block in $SEED_FILE" >&2
  exit 1
fi

if ! echo "$SEED_CHAIN_BLOCK" | rg -n "clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_chain_generator" >/dev/null; then
  echo "[check-decisive-completion-seedwise-no-fallback] FAIL: seedwise chain-generator endpoint theorem does not route via seedwise chain-generator completion theorem" >&2
  echo "$SEED_CHAIN_BLOCK" >&2
  exit 1
fi

SEED_CHAIN_ON_SEEDS_BLOCK="$(
  awk '
    /theorem clayBStatement_from_no_local_fallback_seedwise_chain_on_seeds_and_seed_construction/ {flag=1}
    flag {print}
    flag && /\/-- Final endpoint route from explicit per-instance chain data and constructive seeds\./ {exit}
  ' "$SEED_FILE"
)"

if [[ -z "$SEED_CHAIN_ON_SEEDS_BLOCK" ]]; then
  echo "[check-decisive-completion-seedwise-no-fallback] FAIL: missing seedwise-chain-on-seeds endpoint theorem block in $SEED_FILE" >&2
  exit 1
fi

if ! echo "$SEED_CHAIN_ON_SEEDS_BLOCK" | rg -n "clayBStatement_from_decisive_completion_no_local_fallback_seedwise" >/dev/null; then
  echo "[check-decisive-completion-seedwise-no-fallback] FAIL: seedwise-chain-on-seeds endpoint theorem does not route via direct seedwise completion theorem" >&2
  echo "$SEED_CHAIN_ON_SEEDS_BLOCK" >&2
  exit 1
fi

SEED_COMPONENT_FAMILIES_BLOCK="$(
  awk '
    /theorem clayBStatement_from_no_local_fallback_seedwise_component_families_and_seed_construction/ {flag=1}
    flag {print}
    flag && /\/-- Final endpoint route from explicit component theorem families and constructive seeds\./ {exit}
  ' "$SEED_FILE"
)"

if [[ -z "$SEED_COMPONENT_FAMILIES_BLOCK" ]]; then
  echo "[check-decisive-completion-seedwise-no-fallback] FAIL: missing seedwise-component-families endpoint theorem block in $SEED_FILE" >&2
  exit 1
fi

if ! echo "$SEED_COMPONENT_FAMILIES_BLOCK" | rg -n "clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_data_on_seeds" >/dev/null; then
  echo "[check-decisive-completion-seedwise-no-fallback] FAIL: seedwise-component-families endpoint theorem does not route via seedwise data-on-seeds completion theorem" >&2
  echo "$SEED_COMPONENT_FAMILIES_BLOCK" >&2
  exit 1
fi

SEED_DATA_FAMILY_BLOCK="$(
  awk '
    /theorem clayBStatement_from_no_local_fallback_data_family_and_seed_construction/ {flag=1}
    flag {print}
    flag && /\/-- Final endpoint route from explicit seedwise chain data on chosen seed triples\./ {exit}
  ' "$SEED_FILE"
)"

if [[ -z "$SEED_DATA_FAMILY_BLOCK" ]]; then
  echo "[check-decisive-completion-seedwise-no-fallback] FAIL: missing data-family endpoint theorem block in $SEED_FILE" >&2
  exit 1
fi

if ! echo "$SEED_DATA_FAMILY_BLOCK" | rg -n "clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_data_family" >/dev/null; then
  echo "[check-decisive-completion-seedwise-no-fallback] FAIL: data-family endpoint theorem does not route via seedwise data-family completion theorem" >&2
  echo "$SEED_DATA_FAMILY_BLOCK" >&2
  exit 1
fi

COMPONENT_FAMILY_BLOCK="$(
  awk '
    /theorem clayBStatement_from_no_local_fallback_component_families_and_seed_construction/ {flag=1}
    flag {print}
    flag && /end StatMech\.ContinuumField\.NavierStokes/ {exit}
  ' "$SEED_FILE"
)"

if [[ -z "$COMPONENT_FAMILY_BLOCK" ]]; then
  echo "[check-decisive-completion-seedwise-no-fallback] FAIL: missing component-families endpoint theorem block in $SEED_FILE" >&2
  exit 1
fi

if ! echo "$COMPONENT_FAMILY_BLOCK" | rg -n "clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_global_direct_component_families" >/dev/null; then
  echo "[check-decisive-completion-seedwise-no-fallback] FAIL: component-families endpoint theorem does not route via seedwise global-component-families completion theorem" >&2
  echo "$COMPONENT_FAMILY_BLOCK" >&2
  exit 1
fi

GLOBAL_DIRECT_COMPONENT_BLOCK="$(
  awk '
    /theorem clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_global_direct_component_families/ {flag=1}
    flag {print}
    flag && /\/-- Seedwise no-local-fallback completion route from chain nonemptiness via extracted component families\./ {exit}
  ' "$COMP_FILE"
)"

if [[ -z "$GLOBAL_DIRECT_COMPONENT_BLOCK" ]]; then
  echo "[check-decisive-completion-seedwise-no-fallback] FAIL: missing global-direct-component-families completion theorem block in $COMP_FILE" >&2
  exit 1
fi

for pattern in \
  "clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_data_family" \
  "decisiveSpine_threshold_chain_data_family_of_direct_constructive_components"
do
  if ! echo "$GLOBAL_DIRECT_COMPONENT_BLOCK" | rg -n "$pattern" >/dev/null; then
    echo "[check-decisive-completion-seedwise-no-fallback] FAIL: global-direct-component-families completion theorem missing $pattern" >&2
    echo "$GLOBAL_DIRECT_COMPONENT_BLOCK" >&2
    exit 1
  fi
done

echo "[check-decisive-completion-seedwise-no-fallback] PASS"
