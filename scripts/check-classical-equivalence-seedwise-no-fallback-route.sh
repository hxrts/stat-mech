#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/ClassicalEquivalence.lean"

echo "[check-classical-equivalence-seedwise-no-fallback-route] checking classical-equivalence seedwise no-fallback routes"

if [[ ! -f "$FILE" ]]; then
  echo "[check-classical-equivalence-seedwise-no-fallback-route] FAIL: missing file $FILE" >&2
  exit 1
fi

for pattern in \
  "clayBStatement_classical_equivalent_no_local_fallback_seedwise_chain_generator_route" \
  "clayBStatement_classical_equivalent_no_local_fallback_seedwise_global_direct_component_families_route"
do
  if ! rg -n "$pattern" "$FILE" >/dev/null; then
    echo "[check-classical-equivalence-seedwise-no-fallback-route] FAIL: missing $pattern in $FILE" >&2
    exit 1
  fi
done

CHAIN_BLOCK="$({
  awk '
    /theorem clayBStatement_classical_equivalent_no_local_fallback_seedwise_chain_generator_route/ {flag=1}
    flag {print}
    flag && /\/-- Classical-equivalent route from seedwise no-local-fallback global component-families completion\./ {exit}
  ' "$FILE"
})"

if [[ -z "$CHAIN_BLOCK" ]]; then
  echo "[check-classical-equivalence-seedwise-no-fallback-route] FAIL: missing chain-generator route theorem block" >&2
  exit 1
fi

if ! echo "$CHAIN_BLOCK" | rg -n "clayBStatement_from_no_local_fallback_seedwise_chain_generator_and_seed_construction" >/dev/null; then
  echo "[check-classical-equivalence-seedwise-no-fallback-route] FAIL: chain-generator route theorem does not route via seedwise seed-construction theorem" >&2
  echo "$CHAIN_BLOCK" >&2
  exit 1
fi

GLOBAL_COMPONENT_BLOCK="$({
  awk '
    /theorem clayBStatement_classical_equivalent_no_local_fallback_seedwise_global_direct_component_families_route/ {flag=1}
    flag {print}
    flag && /end StatMech\.ContinuumField\.NavierStokes/ {exit}
  ' "$FILE"
})"

if [[ -z "$GLOBAL_COMPONENT_BLOCK" ]]; then
  echo "[check-classical-equivalence-seedwise-no-fallback-route] FAIL: missing global component-families route theorem block" >&2
  exit 1
fi

if ! echo "$GLOBAL_COMPONENT_BLOCK" | rg -n "clayBStatement_from_no_local_fallback_component_families_and_seed_construction" >/dev/null; then
  echo "[check-classical-equivalence-seedwise-no-fallback-route] FAIL: global component-families route theorem does not route via no-local-fallback component-families seed-construction theorem" >&2
  echo "$GLOBAL_COMPONENT_BLOCK" >&2
  exit 1
fi

echo "[check-classical-equivalence-seedwise-no-fallback-route] PASS"
