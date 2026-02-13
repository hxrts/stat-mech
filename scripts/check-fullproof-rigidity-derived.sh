#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/FullProofExactRigidity.lean"

echo "[check-fullproof-rigidity-derived] checking rigidity derivation route"

for pattern in \
  "FullProofExactLowerFluxHypotheses" \
  "FullProofExactUpperFluxHypotheses" \
  "fullProof_exact_localEnergy_epsilonRegularity" \
  "fullProof_exact_lower_upper_quantitative" \
  "fullProof_exact_rigidity_contradiction"
do
  if ! rg -n "$pattern" "$FILE" >/dev/null; then
    echo "[check-fullproof-rigidity-derived] FAIL: missing $pattern" >&2
    exit 1
  fi
done

if rg -n "^theorem fullProof_exact_localEnergy_epsilonRegularity_direct\\b|^theorem fullProof_exact_lower_upper_quantitative_direct\\b|^theorem fullProof_exact_rigidity_contradiction_direct\\b" "$FILE" >/dev/null; then
  echo "[check-fullproof-rigidity-derived] FAIL: retired full-proof direct wrappers reintroduced" >&2
  rg -n "^theorem fullProof_exact_localEnergy_epsilonRegularity_direct\\b|^theorem fullProof_exact_lower_upper_quantitative_direct\\b|^theorem fullProof_exact_rigidity_contradiction_direct\\b" "$FILE" >&2
  exit 1
fi

if rg -n "theorem fullProof_exact_rigidity_contradiction_of_witnesses\\b" "$FILE" >/dev/null; then
  echo "[check-fullproof-rigidity-derived] FAIL: retired witness-compatibility contradiction theorem reintroduced" >&2
  rg -n "theorem fullProof_exact_rigidity_contradiction_of_witnesses\\b" "$FILE" >&2
  exit 1
fi

WITNESS_BLOCK="$(
  awk '
    /theorem fullProof_exact_rigidity_contradiction$/ {flag=1}
    flag {print}
    flag && /^end Gibbs\.ContinuumField\.NavierStokes/ {exit}
  ' "$FILE"
)"

if [[ -z "$WITNESS_BLOCK" ]]; then
  echo "[check-fullproof-rigidity-derived] FAIL: missing fullProof_exact_rigidity_contradiction block" >&2
  exit 1
fi

for pattern in \
  "hardStep_quantitative_flux_incompatibility" \
  "scaleFlux_tail_vanishes" \
  "lower_flux\\.η" \
  "lower_flux\\.persistent_flux"
do
  if ! echo "$WITNESS_BLOCK" | rg -n "$pattern" >/dev/null; then
    echo "[check-fullproof-rigidity-derived] FAIL: fullProof_exact_rigidity_contradiction missing $pattern" >&2
    echo "$WITNESS_BLOCK" >&2
    exit 1
  fi
done

if echo "$WITNESS_BLOCK" | rg -n "hardStep_flux_barrier_contradiction" >/dev/null; then
  echo "[check-fullproof-rigidity-derived] FAIL: fullProof_exact_rigidity_contradiction still routes through hardStep_flux_barrier_contradiction wrapper" >&2
  echo "$WITNESS_BLOCK" >&2
  exit 1
fi

if echo "$WITNESS_BLOCK" | rg -n "hardStep_lower_flux_hypotheses_of_witness|hardStep_upper_flux_hypotheses_of_witness" >/dev/null; then
  echo "[check-fullproof-rigidity-derived] FAIL: fullProof_exact_rigidity_contradiction still uses retired witness-to-hypothesis helper theorems" >&2
  echo "$WITNESS_BLOCK" >&2
  exit 1
fi

LOCAL_BLOCK="$(
  awk '
    /theorem fullProof_exact_localEnergy_epsilonRegularity$/ {flag=1}
    flag {print}
    flag && /^\/-- Exact lower\/upper quantitative theorem package\./ {exit}
  ' "$FILE"
)"

if [[ -z "$LOCAL_BLOCK" ]]; then
  echo "[check-fullproof-rigidity-derived] FAIL: missing fullProof_exact_localEnergy_epsilonRegularity block" >&2
  exit 1
fi

if ! echo "$LOCAL_BLOCK" | rg -n "baseAxiom_local_energy_epsilon_regularity" >/dev/null; then
  echo "[check-fullproof-rigidity-derived] FAIL: local-energy theorem is not routed through baseAxiom_local_energy_epsilon_regularity" >&2
  echo "$LOCAL_BLOCK" >&2
  exit 1
fi

if echo "$LOCAL_BLOCK" | rg -n "baseAxiom_local_energy_epsilon_regularity_direct|fullProof_exact_localEnergy_epsilonRegularity_direct" >/dev/null; then
  echo "[check-fullproof-rigidity-derived] FAIL: local-energy theorem still uses retired direct wrappers" >&2
  echo "$LOCAL_BLOCK" >&2
  exit 1
fi

QUANT_BLOCK="$(
  awk '
    /theorem fullProof_exact_lower_upper_quantitative$/ {flag=1}
    flag {print}
    flag && /^\/-- Exact contradiction theorem for the full-proof route\./ {exit}
  ' "$FILE"
)"

if [[ -z "$QUANT_BLOCK" ]]; then
  echo "[check-fullproof-rigidity-derived] FAIL: missing fullProof_exact_lower_upper_quantitative block" >&2
  exit 1
fi

for pattern in \
  "baseAxiom_lower_cascade_from_minimality" \
  "baseAxiom_upper_tail_vanishing"
do
  if ! echo "$QUANT_BLOCK" | rg -n "$pattern" >/dev/null; then
    echo "[check-fullproof-rigidity-derived] FAIL: lower/upper quantitative theorem missing $pattern" >&2
    echo "$QUANT_BLOCK" >&2
    exit 1
  fi
done

if echo "$QUANT_BLOCK" | rg -n "baseAxiom_lower_cascade_from_minimality_direct|baseAxiom_upper_tail_vanishing_direct|fullProof_exact_lower_upper_quantitative_direct" >/dev/null; then
  echo "[check-fullproof-rigidity-derived] FAIL: lower/upper quantitative theorem still uses retired direct wrappers" >&2
  echo "$QUANT_BLOCK" >&2
  exit 1
fi

if rg -n '^import Gibbs\.ContinuumField\.NavierStokes\.HardStep\.Definitive\.' "$FILE" >/dev/null; then
  echo "[check-fullproof-rigidity-derived] FAIL: full-proof rigidity imports definitive hard-step modules" >&2
  exit 1
fi

echo "[check-fullproof-rigidity-derived] PASS"
