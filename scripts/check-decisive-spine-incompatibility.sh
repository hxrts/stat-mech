#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveSpineIncompatibility.lean"

echo "[check-decisive-spine-incompatibility] checking incompatibility layer"

for pattern in \
  "decisiveSpine_crux_incompatibility" \
  "decisiveSpine_incompatibility_theorem" \
  "decisiveSpine_excludes_all_minimal_elements" \
  "DecisiveSpineAstarInfinite" \
  "decisiveSpine_Astar_infinite" \
  "hardStep_quantitative_flux_incompatibility"
do
  if ! rg -n "$pattern" "$FILE" >/dev/null; then
    echo "[check-decisive-spine-incompatibility] FAIL: missing $pattern" >&2
    exit 1
  fi
done

CRUX_BLOCK="$(
  awk '
    /theorem decisiveSpine_crux_incompatibility/ {flag=1}
    flag {print}
    flag && /\/-- Decisive incompatibility theorem: lower \+ upper mechanisms imply contradiction\./ {exit}
  ' "$FILE"
)"

if [[ -z "$CRUX_BLOCK" ]]; then
  echo "[check-decisive-spine-incompatibility] FAIL: missing decisiveSpine_crux_incompatibility block" >&2
  exit 1
fi

if ! echo "$CRUX_BLOCK" | rg -n "hardStep_quantitative_flux_incompatibility" >/dev/null; then
  echo "[check-decisive-spine-incompatibility] FAIL: decisive spine crux theorem is not routed through hardStep_quantitative_flux_incompatibility" >&2
  echo "$CRUX_BLOCK" >&2
  exit 1
fi

if echo "$CRUX_BLOCK" | rg -n "hardStep_flux_barrier_contradiction" >/dev/null; then
  echo "[check-decisive-spine-incompatibility] FAIL: decisive spine crux theorem still routes through hardStep_flux_barrier_contradiction wrapper" >&2
  echo "$CRUX_BLOCK" >&2
  exit 1
fi

if rg -n "theorem decisiveSpine_incompatibility_from_witness\\b" "$FILE" >/dev/null; then
  echo "[check-decisive-spine-incompatibility] FAIL: retired witness-compatibility incompatibility theorem reintroduced" >&2
  rg -n "theorem decisiveSpine_incompatibility_from_witness\\b" "$FILE" >&2
  exit 1
fi

echo "[check-decisive-spine-incompatibility] PASS"
