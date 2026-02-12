#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HARDSTEP_FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/TrueHardStep.lean"
GLOBAL_FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveGlobal.lean"

echo "[check-hardstep-quantitative-route] checking hard-step quantitative route"

for pattern in \
  "QuantitativeProfileDecompositionTheorem" \
  "QuantitativeMinimalElementExtraction" \
  "QuantitativeLowerCascadeTheorem" \
  "QuantitativeUpperTailTheorem" \
  "QuantitativeHardStepContradiction" \
  "hardStep_Astar_infinite"
do
  if ! rg -n "$pattern" "$HARDSTEP_FILE" >/dev/null; then
    echo "[check-hardstep-quantitative-route] FAIL: missing $pattern" >&2
    exit 1
  fi
done

if ! rg -n "decisiveGlobalClosureTheorem_of_hardStepControl" "$GLOBAL_FILE" >/dev/null; then
  echo "[check-hardstep-quantitative-route] FAIL: global closure is not routed through hard-step control theorem" >&2
  exit 1
fi

echo "[check-hardstep-quantitative-route] PASS"
