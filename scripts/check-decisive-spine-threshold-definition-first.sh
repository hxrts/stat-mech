#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveSpineThreshold.lean"

echo "[check-decisive-spine-threshold-definition-first] checking definition-first threshold route"

for pattern in \
  "DecisiveContinuationFailurePredicate" \
  "DecisiveAstarFromFailure" \
  "decisiveDefinitionFirst_threshold_foundations"
do
  if ! rg -n "$pattern" "$FILE" >/dev/null; then
    echo "[check-decisive-spine-threshold-definition-first] FAIL: missing $pattern" >&2
    exit 1
  fi
done

if rg -n '^import Gibbs\.ContinuumField\.NavierStokes\.HardStep\.Definitive\.' "$FILE" >/dev/null; then
  echo "[check-decisive-spine-threshold-definition-first] FAIL: threshold route imports definitive hard-step packages" >&2
  exit 1
fi

if rg -n "^def decisiveAstarFromFailure_direct\\b|^theorem decisiveDefinitionFirst_threshold_foundations_direct\\b" "$FILE" >/dev/null; then
  echo "[check-decisive-spine-threshold-definition-first] FAIL: retired threshold direct wrappers reintroduced" >&2
  rg -n "^def decisiveAstarFromFailure_direct\\b|^theorem decisiveDefinitionFirst_threshold_foundations_direct\\b" "$FILE" >&2
  exit 1
fi

echo "[check-decisive-spine-threshold-definition-first] PASS"
