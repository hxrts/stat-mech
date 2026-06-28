#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/BaseAxiomRigidity.lean"

echo "[check-base-axiom-rigidity-imports] checking imports in $FILE"

if rg -n '^import StatMech\.ContinuumField\.NavierStokes\.Faithful\.' "$FILE" | rg -v 'Faithful\.BaseAxiomCompactness' >/dev/null; then
  echo "[check-base-axiom-rigidity-imports] FAIL: rigidity module imports non-base faithful wrappers" >&2
  exit 1
fi

BLOCK="$(
  awk '
    /theorem baseAxiom_flux_barrier_contradiction_from_hypotheses/ {flag=1}
    flag {print}
    flag && /\/-- Primitive all-minimal exclusion consequence used by global-control derivation\./ {exit}
  ' "$FILE"
)"

if [[ -z "$BLOCK" ]]; then
  echo "[check-base-axiom-rigidity-imports] FAIL: missing baseAxiom_flux_barrier_contradiction_from_hypotheses block" >&2
  exit 1
fi

if ! echo "$BLOCK" | rg -n "hardStep_quantitative_flux_incompatibility" >/dev/null; then
  echo "[check-base-axiom-rigidity-imports] FAIL: baseAxiom_flux_barrier_contradiction_from_hypotheses is not routed through hardStep_quantitative_flux_incompatibility" >&2
  echo "$BLOCK" >&2
  exit 1
fi

WITNESS_BLOCK="$(
  awk '
    /theorem baseAxiom_flux_barrier_contradiction$/ {flag=1}
    flag {print}
    flag && /\/-! ## Flux hypothesis definitions -\// {exit}
  ' "$FILE"
)"

if [[ -z "$WITNESS_BLOCK" ]]; then
  echo "[check-base-axiom-rigidity-imports] FAIL: missing baseAxiom_flux_barrier_contradiction block" >&2
  exit 1
fi

for pattern in \
  "hardStep_quantitative_flux_incompatibility" \
  "scaleFlux_tail_vanishes" \
  "lower_flux\\.η" \
  "lower_flux\\.persistent_flux"
do
  if ! echo "$WITNESS_BLOCK" | rg -n "$pattern" >/dev/null; then
    echo "[check-base-axiom-rigidity-imports] FAIL: baseAxiom_flux_barrier_contradiction missing $pattern" >&2
    echo "$WITNESS_BLOCK" >&2
    exit 1
  fi
done

if echo "$WITNESS_BLOCK" | rg -n "hardStep_flux_barrier_contradiction" >/dev/null; then
  echo "[check-base-axiom-rigidity-imports] FAIL: baseAxiom_flux_barrier_contradiction still routes through hardStep_flux_barrier_contradiction wrapper" >&2
  echo "$WITNESS_BLOCK" >&2
  exit 1
fi

if echo "$WITNESS_BLOCK" | rg -n "hardStep_lower_flux_hypotheses_of_witness|hardStep_upper_flux_hypotheses_of_witness|hardStep_flux_barrier_contradiction_of_witnesses" >/dev/null; then
  echo "[check-base-axiom-rigidity-imports] FAIL: baseAxiom_flux_barrier_contradiction still uses retired hardStep witness compatibility helpers/theorem" >&2
  echo "$WITNESS_BLOCK" >&2
  exit 1
fi

if rg -n "^theorem baseAxiom_flux_barrier_contradiction_direct\\b" "$FILE" >/dev/null; then
  echo "[check-base-axiom-rigidity-imports] FAIL: duplicate baseAxiom_flux_barrier_contradiction_direct wrapper reintroduced" >&2
  rg -n "^theorem baseAxiom_flux_barrier_contradiction_direct\\b" "$FILE" >&2
  exit 1
fi

if rg -n "^theorem baseAxiom_local_energy_epsilon_regularity_direct\\b|^theorem baseAxiom_lower_cascade_from_minimality_direct\\b|^theorem baseAxiom_upper_tail_vanishing_direct\\b|^theorem baseAxiom_excludes_all_minimal_elements_direct\\b" "$FILE" >/dev/null; then
  echo "[check-base-axiom-rigidity-imports] FAIL: retired base-axiom direct wrappers reintroduced" >&2
  rg -n "^theorem baseAxiom_local_energy_epsilon_regularity_direct\\b|^theorem baseAxiom_lower_cascade_from_minimality_direct\\b|^theorem baseAxiom_upper_tail_vanishing_direct\\b|^theorem baseAxiom_excludes_all_minimal_elements_direct\\b" "$FILE" >&2
  exit 1
fi

echo "[check-base-axiom-rigidity-imports] PASS"
