#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveGlobal.lean"

echo "[check-decisive-global-no-fallback-chain-generator-route] checking no-fallback chain-generator route"

if [[ ! -f "$FILE" ]]; then
  echo "[check-decisive-global-no-fallback-chain-generator-route] FAIL: missing file $FILE" >&2
  exit 1
fi

BLOCK="$(
  awk '
    /def decisiveGlobalClosureTheorem_no_local_fallback_of_chain_generator/ {flag=1}
    flag {print}
    flag && /\/-- Unconditional global closure theorem interface from decisive hard step/ {exit}
  ' "$FILE"
)"

if [[ -z "$BLOCK" ]]; then
  echo "[check-decisive-global-no-fallback-chain-generator-route] FAIL: missing no-fallback chain-generator theorem block" >&2
  exit 1
fi

for pattern in \
  "chain_generator H M A L" \
  "decisiveGlobalClosureTheorem_from_threshold_minimal_chain"
do
  if ! echo "$BLOCK" | rg -n "$pattern" >/dev/null; then
    echo "[check-decisive-global-no-fallback-chain-generator-route] FAIL: theorem block missing $pattern" >&2
    echo "$BLOCK" >&2
    exit 1
  fi
done

if echo "$BLOCK" | rg -n "decisiveGlobalClosureTheorem_localTheory_fallback" >/dev/null; then
  echo "[check-decisive-global-no-fallback-chain-generator-route] FAIL: no-fallback theorem references local fallback" >&2
  echo "$BLOCK" >&2
  exit 1
fi

if rg -n "def decisiveGlobalClosureTheorem_no_local_fallback_of_component_families" "$FILE" >/dev/null; then
  echo "[check-decisive-global-no-fallback-chain-generator-route] FAIL: legacy non-seedwise component-families no-fallback global-closure definition reintroduced in $FILE" >&2
  exit 1
fi

echo "[check-decisive-global-no-fallback-chain-generator-route] PASS"
