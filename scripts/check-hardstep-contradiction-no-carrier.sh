#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/StatMech/ContinuumField/NavierStokes/HardStep/ContradictionClosure.lean"
TARGET_DIR="$ROOT/StatMech"

echo "[check-hardstep-contradiction-no-carrier] checking hard-step contradiction de-carrierization"

if [[ ! -f "$FILE" ]]; then
  echo "[check-hardstep-contradiction-no-carrier] FAIL: missing file $FILE" >&2
  exit 1
fi

if rg -n "HardStepFluxContradictionPackage" "$TARGET_DIR" >/dev/null; then
  echo "[check-hardstep-contradiction-no-carrier] FAIL: legacy contradiction package carrier token reintroduced in $TARGET_DIR" >&2
  exit 1
fi

for pattern in \
  "abbrev HardStepLowerFluxHypotheses" \
  "abbrev HardStepUpperFluxHypotheses" \
  "theorem hardStep_quantitative_flux_incompatibility" \
  "theorem hardStep_global_closure_of_flux_hypotheses" \
  "def HardStepGlobalClosure" \
  "hardStep_flux_barrier_contradiction"
do
  if ! rg -n "$pattern" "$FILE" >/dev/null; then
    echo "[check-hardstep-contradiction-no-carrier] FAIL: missing expected token in de-carrierized theorem surface: $pattern" >&2
    exit 1
  fi
done

CRUX_BLOCK="$(
  awk '
    /theorem hardStep_flux_barrier_contradiction/ {flag=1}
    flag {print}
    flag && /^\/-- Hard-step global-closure statement:/ {exit}
  ' "$FILE"
)"

if [[ -z "$CRUX_BLOCK" ]]; then
  echo "[check-hardstep-contradiction-no-carrier] FAIL: missing hardStep_flux_barrier_contradiction block" >&2
  exit 1
fi

if ! echo "$CRUX_BLOCK" | rg -n "hardStep_quantitative_flux_incompatibility" >/dev/null; then
  echo "[check-hardstep-contradiction-no-carrier] FAIL: hardStep_flux_barrier_contradiction is not routed through hardStep_quantitative_flux_incompatibility" >&2
  echo "$CRUX_BLOCK" >&2
  exit 1
fi

if rg -n "theorem hardStep_lower_flux_hypotheses_of_witness\\b|theorem hardStep_upper_flux_hypotheses_of_witness\\b|theorem hardStep_flux_barrier_contradiction_of_witnesses\\b|theorem hardStep_global_closure_of_flux_barrier\\b" "$FILE" >/dev/null; then
  echo "[check-hardstep-contradiction-no-carrier] FAIL: retired witness-compatibility helpers/wrappers reintroduced in contradiction closure" >&2
  rg -n "theorem hardStep_lower_flux_hypotheses_of_witness\\b|theorem hardStep_upper_flux_hypotheses_of_witness\\b|theorem hardStep_flux_barrier_contradiction_of_witnesses\\b|theorem hardStep_global_closure_of_flux_barrier\\b" "$FILE" >&2
  exit 1
fi

echo "[check-hardstep-contradiction-no-carrier] PASS"
