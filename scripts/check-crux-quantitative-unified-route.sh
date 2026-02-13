#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HARDSTEP_FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/HardStep/ContradictionClosure.lean"
DEFINITIVE_FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/HardStep/Definitive/TrueTorusFluxBarrier.lean"
BASE_AXIOM_FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomRigidity.lean"
DECISIVE_FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveSpineIncompatibility.lean"
FULLPROOF_FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/FullProofExactRigidity.lean"

echo "[check-crux-quantitative-unified-route] checking unified quantitative crux routing"

for f in "$HARDSTEP_FILE" "$DEFINITIVE_FILE" "$BASE_AXIOM_FILE" "$DECISIVE_FILE" "$FULLPROOF_FILE"; do
  if [[ ! -f "$f" ]]; then
    echo "[check-crux-quantitative-unified-route] FAIL: missing file $f" >&2
    exit 1
  fi
done

extract_block() {
  local file="$1"
  local start_pat="$2"
  local end_pat="$3"
  awk -v s="$start_pat" -v e="$end_pat" '
    $0 ~ s {flag=1}
    flag {print}
    flag && $0 ~ e {exit}
  ' "$file"
}

HARDSTEP_BLOCK="$(extract_block "$HARDSTEP_FILE" "^theorem hardStep_flux_barrier_contradiction" "^/-- Hard-step global-closure statement:")"
if [[ -z "$HARDSTEP_BLOCK" ]]; then
  echo "[check-crux-quantitative-unified-route] FAIL: missing hardStep_flux_barrier_contradiction block" >&2
  exit 1
fi
if ! echo "$HARDSTEP_BLOCK" | rg -n "hardStep_quantitative_flux_incompatibility" >/dev/null; then
  echo "[check-crux-quantitative-unified-route] FAIL: hardStep flux barrier contradiction is not routed through quantitative crux theorem" >&2
  exit 1
fi

DEFINITIVE_BLOCK="$(extract_block "$DEFINITIVE_FILE" "^theorem definitive_flux_barrier_contradiction" "^/-- Definitive exclusion theorem for minimal blow-up elements\\.")"
if [[ -z "$DEFINITIVE_BLOCK" ]]; then
  echo "[check-crux-quantitative-unified-route] FAIL: missing definitive_flux_barrier_contradiction block" >&2
  exit 1
fi
if ! echo "$DEFINITIVE_BLOCK" | rg -n "hardStep_quantitative_flux_incompatibility" >/dev/null; then
  echo "[check-crux-quantitative-unified-route] FAIL: definitive contradiction is not routed through quantitative crux theorem" >&2
  exit 1
fi
if echo "$DEFINITIVE_BLOCK" | rg -n "hardStep_flux_barrier_contradiction" >/dev/null; then
  echo "[check-crux-quantitative-unified-route] FAIL: definitive contradiction still routes through wrapper theorem" >&2
  exit 1
fi

BASE_AXIOM_BLOCK="$(extract_block "$BASE_AXIOM_FILE" "^theorem baseAxiom_flux_barrier_contradiction$" "^/-! ## Flux hypothesis definitions -/")"
if [[ -z "$BASE_AXIOM_BLOCK" ]]; then
  echo "[check-crux-quantitative-unified-route] FAIL: missing baseAxiom_flux_barrier_contradiction block" >&2
  exit 1
fi
if ! echo "$BASE_AXIOM_BLOCK" | rg -n "hardStep_quantitative_flux_incompatibility" >/dev/null; then
  echo "[check-crux-quantitative-unified-route] FAIL: base-axiom witness contradiction is not routed through quantitative crux theorem" >&2
  exit 1
fi
if echo "$BASE_AXIOM_BLOCK" | rg -n "hardStep_flux_barrier_contradiction" >/dev/null; then
  echo "[check-crux-quantitative-unified-route] FAIL: base-axiom witness contradiction still routes through wrapper theorem" >&2
  exit 1
fi

BASE_AXIOM_DIRECT_BLOCK="$(extract_block "$BASE_AXIOM_FILE" "^theorem baseAxiom_flux_barrier_contradiction_from_hypotheses" "^/-- Primitive all-minimal exclusion consequence used by global-control derivation\\.")"
if [[ -z "$BASE_AXIOM_DIRECT_BLOCK" ]]; then
  echo "[check-crux-quantitative-unified-route] FAIL: missing baseAxiom_flux_barrier_contradiction_from_hypotheses block" >&2
  exit 1
fi
if ! echo "$BASE_AXIOM_DIRECT_BLOCK" | rg -n "hardStep_quantitative_flux_incompatibility" >/dev/null; then
  echo "[check-crux-quantitative-unified-route] FAIL: base-axiom direct contradiction is not routed through quantitative crux theorem" >&2
  exit 1
fi
if echo "$BASE_AXIOM_DIRECT_BLOCK" | rg -n "hardStep_flux_barrier_contradiction" >/dev/null; then
  echo "[check-crux-quantitative-unified-route] FAIL: base-axiom direct contradiction still routes through wrapper theorem" >&2
  exit 1
fi

DECISIVE_BLOCK="$(extract_block "$DECISIVE_FILE" "^theorem decisiveSpine_crux_incompatibility" "^/-- Decisive incompatibility theorem: lower \\+ upper mechanisms imply contradiction\\.")"
if [[ -z "$DECISIVE_BLOCK" ]]; then
  echo "[check-crux-quantitative-unified-route] FAIL: missing decisiveSpine_crux_incompatibility block" >&2
  exit 1
fi
if ! echo "$DECISIVE_BLOCK" | rg -n "hardStep_quantitative_flux_incompatibility" >/dev/null; then
  echo "[check-crux-quantitative-unified-route] FAIL: decisive spine crux is not routed through quantitative crux theorem" >&2
  exit 1
fi
if echo "$DECISIVE_BLOCK" | rg -n "hardStep_flux_barrier_contradiction" >/dev/null; then
  echo "[check-crux-quantitative-unified-route] FAIL: decisive spine crux still routes through wrapper theorem" >&2
  exit 1
fi

FULLPROOF_BLOCK="$(extract_block "$FULLPROOF_FILE" "^theorem fullProof_exact_rigidity_contradiction$" "^end Gibbs\\.ContinuumField\\.NavierStokes")"
if [[ -z "$FULLPROOF_BLOCK" ]]; then
  echo "[check-crux-quantitative-unified-route] FAIL: missing fullProof_exact_rigidity_contradiction block" >&2
  exit 1
fi
if ! echo "$FULLPROOF_BLOCK" | rg -n "hardStep_quantitative_flux_incompatibility" >/dev/null; then
  echo "[check-crux-quantitative-unified-route] FAIL: full-proof contradiction is not routed through quantitative crux theorem" >&2
  exit 1
fi
if echo "$FULLPROOF_BLOCK" | rg -n "hardStep_flux_barrier_contradiction" >/dev/null; then
  echo "[check-crux-quantitative-unified-route] FAIL: full-proof contradiction still routes through wrapper theorem" >&2
  exit 1
fi

if rg -n "hardStep_flux_barrier_contradiction" \
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful" \
  "$ROOT/Gibbs/ContinuumField/NavierStokes/HardStep/Definitive" >/dev/null; then
  echo "[check-crux-quantitative-unified-route] FAIL: wrapper theorem call still present in faithful/definitive contradiction cone" >&2
  rg -n "hardStep_flux_barrier_contradiction" \
    "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful" \
    "$ROOT/Gibbs/ContinuumField/NavierStokes/HardStep/Definitive" >&2
  exit 1
fi

echo "[check-crux-quantitative-unified-route] PASS"
