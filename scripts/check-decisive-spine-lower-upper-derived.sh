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

for pattern in \
  "decisiveSpine_upper_mechanism_quantitative" \
  "decisiveSpine_upper_limit_exchanges"
do
  if ! rg -n "$pattern" "$UPPER" >/dev/null; then
    echo "[check-decisive-spine-lower-upper-derived] FAIL: missing $pattern in upper layer" >&2
    exit 1
  fi
done

if rg -n 'structure\s+DecisiveSpineUpperLimitExchange\b' "$UPPER" >/dev/null; then
  echo "[check-decisive-spine-lower-upper-derived] FAIL: upper layer still uses DecisiveSpineUpperLimitExchange carrier structure" >&2
  exit 1
fi

echo "[check-decisive-spine-lower-upper-derived] PASS"
