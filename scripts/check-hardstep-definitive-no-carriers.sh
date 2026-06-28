#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LOWER_FILE="$ROOT/StatMech/ContinuumField/NavierStokes/HardStep/Definitive/TrueTorusLowerFluxRigidity.lean"
UPPER_FILE="$ROOT/StatMech/ContinuumField/NavierStokes/HardStep/Definitive/TrueTorusUpperTailVanishing.lean"
BARRIER_FILE="$ROOT/StatMech/ContinuumField/NavierStokes/HardStep/Definitive/TrueTorusFluxBarrier.lean"
GLOBAL_FILE="$ROOT/StatMech/ContinuumField/NavierStokes/HardStep/Definitive/GlobalClosure.lean"
CLAYB_FILE="$ROOT/StatMech/ContinuumField/NavierStokes/HardStep/Definitive/ClayB.lean"
DERIVED_FILE="$ROOT/StatMech/ContinuumField/NavierStokes/HardStep/Definitive/DerivedTheorems.lean"

echo "[check-hardstep-definitive-no-carriers] checking definitive hard-step de-carrierization"

for f in "$LOWER_FILE" "$UPPER_FILE" "$BARRIER_FILE" "$GLOBAL_FILE" "$CLAYB_FILE" "$DERIVED_FILE"; do
  if [[ ! -f "$f" ]]; then
    echo "[check-hardstep-definitive-no-carriers] FAIL: missing file $f" >&2
    exit 1
  fi
done

for forbidden in \
  "structure DefinitiveLowerFluxRigidityTheorem" \
  "structure DefinitiveUpperTailVanishingTheorem" \
  "structure DefinitiveFluxBarrierContradiction" \
  "structure DefinitiveGlobalClosurePackage" \
  "structure DefinitiveClosureToClayBBridge" \
  "structure DefinitiveDerivedTheoremSuite"
do
  if rg -n "$forbidden" "$LOWER_FILE" "$UPPER_FILE" "$BARRIER_FILE" "$GLOBAL_FILE" "$CLAYB_FILE" "$DERIVED_FILE" >/dev/null; then
    echo "[check-hardstep-definitive-no-carriers] FAIL: forbidden definitive carrier reintroduced: $forbidden" >&2
    exit 1
  fi
done

if [[ -f "$ROOT/StatMech/ContinuumField/NavierStokes/HardStep/Definitive/CriticalElement.lean" ]]; then
  echo "[check-hardstep-definitive-no-carriers] FAIL: retired CriticalElement module reintroduced" >&2
  exit 1
fi

for required in \
  "abbrev DefinitiveLowerFluxHypotheses" \
  "theorem definitive_lower_flux_bound" \
  "theorem definitive_lower_flux_persistence"
do
  if ! rg -n "$required" "$LOWER_FILE" >/dev/null; then
    echo "[check-hardstep-definitive-no-carriers] FAIL: missing required lower definitive endpoint: $required" >&2
    exit 1
  fi
done

for required in \
  "abbrev DefinitiveUpperFluxHypotheses" \
  "theorem definitive_high_frequency_flux_tail_vanishing" \
  "theorem definitive_integrated_defect_tail_vanishing" \
  "theorem definitive_tail_limit_exchanges"
do
  if ! rg -n "$required" "$UPPER_FILE" >/dev/null; then
    echo "[check-hardstep-definitive-no-carriers] FAIL: missing required upper definitive endpoint: $required" >&2
    exit 1
  fi
done

for required in \
  "theorem definitive_flux_barrier_contradiction" \
  "theorem definitive_excludes_all_minimal_elements_direct" \
  "theorem definitive_excludes_all_minimal_elements" \
  "theorem definitive_global_closure_unconditional_direct" \
  "theorem definitive_global_closure_unconditional" \
  "hardStep_quantitative_flux_incompatibility"
do
  if ! rg -n "$required" "$BARRIER_FILE" >/dev/null; then
    echo "[check-hardstep-definitive-no-carriers] FAIL: missing required flux-barrier endpoint token: $required" >&2
    exit 1
  fi
done

BARRIER_BLOCK="$(
  awk '
    /theorem definitive_flux_barrier_contradiction/ {flag=1}
    flag {print}
    flag && /^\/-- Definitive exclusion theorem for minimal blow-up elements\./ {exit}
  ' "$BARRIER_FILE"
)"

if [[ -z "$BARRIER_BLOCK" ]]; then
  echo "[check-hardstep-definitive-no-carriers] FAIL: missing definitive_flux_barrier_contradiction block" >&2
  exit 1
fi

if ! echo "$BARRIER_BLOCK" | rg -n "hardStep_quantitative_flux_incompatibility" >/dev/null; then
  echo "[check-hardstep-definitive-no-carriers] FAIL: definitive flux-barrier contradiction is not routed through hardStep_quantitative_flux_incompatibility" >&2
  echo "$BARRIER_BLOCK" >&2
  exit 1
fi

if echo "$BARRIER_BLOCK" | rg -n "hardStep_flux_barrier_contradiction" >/dev/null; then
  echo "[check-hardstep-definitive-no-carriers] FAIL: definitive flux-barrier contradiction still routes through hardStep_flux_barrier_contradiction wrapper" >&2
  echo "$BARRIER_BLOCK" >&2
  exit 1
fi

for required in \
  "theorem definitiveHardStepGlobalClosure" \
  "excludes_all_minimal"
do
  if ! rg -n "$required" "$GLOBAL_FILE" >/dev/null; then
    echo "[check-hardstep-definitive-no-carriers] FAIL: missing required definitive global-closure endpoint token: $required" >&2
    exit 1
  fi
done

for required in \
  "def definitiveCoreLemma_of_globalClosure" \
  "def unresolvedLemma_replaced_by_definitiveCore" \
  "theorem definitiveClayBStatement" \
  "regularity_of_closure" \
  "definitiveHardStepGlobalClosure"
do
  if ! rg -n "$required" "$CLAYB_FILE" >/dev/null; then
    echo "[check-hardstep-definitive-no-carriers] FAIL: missing required definitive ClayB endpoint token: $required" >&2
    exit 1
  fi
done

echo "[check-hardstep-definitive-no-carriers] PASS"
