#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LOWER="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveSpineLowerMechanism.lean"
UPPER="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveSpineUpperMechanism.lean"

echo "[check-decisive-spine-lower-upper-derived] checking lower/upper mechanisms"

for pattern in \
  "decisiveSpine_lower_mechanism_quantitative" \
  "decisiveSpine_lower_mechanism_persistence"
do
  if ! rg -n "$pattern" "$LOWER" >/dev/null; then
    echo "[check-decisive-spine-lower-upper-derived] FAIL: missing $pattern in lower layer" >&2
    exit 1
  fi
done

LOWER_QUANT_BLOCK="$(
  awk '
    /theorem decisiveSpine_lower_mechanism_quantitative$/ {flag=1}
    flag {print}
    flag && /^\/-- Lower-mechanism persistence theorem across extracted scale route\./ {exit}
  ' "$LOWER"
)"

if [[ -z "$LOWER_QUANT_BLOCK" ]]; then
  echo "[check-decisive-spine-lower-upper-derived] FAIL: missing decisiveSpine_lower_mechanism_quantitative block" >&2
  exit 1
fi

if ! echo "$LOWER_QUANT_BLOCK" | rg -n "minimal_element_forces_persistent_cascade" >/dev/null; then
  echo "[check-decisive-spine-lower-upper-derived] FAIL: lower quantitative theorem is not routed through minimal_element_forces_persistent_cascade" >&2
  echo "$LOWER_QUANT_BLOCK" >&2
  exit 1
fi

LOWER_PERSIST_BLOCK="$(
  awk '
    /theorem decisiveSpine_lower_mechanism_persistence$/ {flag=1}
    flag {print}
    flag && /^\/-- Lower-mechanism policy marker for decisive spine\./ {exit}
  ' "$LOWER"
)"

if [[ -z "$LOWER_PERSIST_BLOCK" ]]; then
  echo "[check-decisive-spine-lower-upper-derived] FAIL: missing decisiveSpine_lower_mechanism_persistence block" >&2
  exit 1
fi

for pattern in \
  "lower_flux\\.η" \
  "lower_flux\\.persistent_flux"
do
  if ! echo "$LOWER_PERSIST_BLOCK" | rg -n "$pattern" >/dev/null; then
    echo "[check-decisive-spine-lower-upper-derived] FAIL: lower persistence theorem missing $pattern" >&2
    echo "$LOWER_PERSIST_BLOCK" >&2
    exit 1
  fi
done

if rg -n "^theorem decisiveSpine_lower_mechanism_quantitative_direct\\b|^theorem decisiveSpine_lower_mechanism_persistence_direct\\b" "$LOWER" >/dev/null; then
  echo "[check-decisive-spine-lower-upper-derived] FAIL: retired decisive-spine lower direct wrappers reintroduced" >&2
  rg -n "^theorem decisiveSpine_lower_mechanism_quantitative_direct\\b|^theorem decisiveSpine_lower_mechanism_persistence_direct\\b" "$LOWER" >&2
  exit 1
fi

for pattern in \
  "decisiveSpine_upper_mechanism_quantitative" \
  "decisiveSpine_upper_limit_exchanges"
do
  if ! rg -n "$pattern" "$UPPER" >/dev/null; then
    echo "[check-decisive-spine-lower-upper-derived] FAIL: missing $pattern in upper layer" >&2
    exit 1
  fi
done

UPPER_BLOCK="$(
  awk '
    /theorem decisiveSpine_upper_mechanism_quantitative$/ {flag=1}
    flag {print}
    flag && /^\/-- Theorem interface for required upper-route limit exchanges\./ {exit}
  ' "$UPPER"
)"

if [[ -z "$UPPER_BLOCK" ]]; then
  echo "[check-decisive-spine-lower-upper-derived] FAIL: missing decisiveSpine_upper_mechanism_quantitative block" >&2
  exit 1
fi

if ! echo "$UPPER_BLOCK" | rg -n "baseAxiom_upper_tail_vanishing" >/dev/null; then
  echo "[check-decisive-spine-lower-upper-derived] FAIL: upper mechanism theorem is not routed through baseAxiom_upper_tail_vanishing" >&2
  echo "$UPPER_BLOCK" >&2
  exit 1
fi

if echo "$UPPER_BLOCK" | rg -n "baseAxiom_upper_tail_vanishing_direct|decisiveSpine_upper_mechanism_quantitative_direct" >/dev/null; then
  echo "[check-decisive-spine-lower-upper-derived] FAIL: upper mechanism theorem still uses retired direct wrappers" >&2
  echo "$UPPER_BLOCK" >&2
  exit 1
fi

if rg -n "^theorem decisiveSpine_upper_mechanism_quantitative_direct\\b" "$UPPER" >/dev/null; then
  echo "[check-decisive-spine-lower-upper-derived] FAIL: retired decisive-spine upper direct wrapper reintroduced" >&2
  rg -n "^theorem decisiveSpine_upper_mechanism_quantitative_direct\\b" "$UPPER" >&2
  exit 1
fi

if rg -n 'structure\s+DecisiveSpineUpperLimitExchange\b' "$UPPER" >/dev/null; then
  echo "[check-decisive-spine-lower-upper-derived] FAIL: upper layer still uses DecisiveSpineUpperLimitExchange carrier structure" >&2
  exit 1
fi

echo "[check-decisive-spine-lower-upper-derived] PASS"
