#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/FullProofExactLocalTheory.lean"
ENDPOINT_FILE="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/BaseAxiomCompletion.lean"

echo "[check-fullproof-local-theory-derived] checking local-theory derivation route"

for pattern in \
  "fullProof_exact_contraction_and_local_existence" \
  "fullProof_exact_uniqueness_and_strongMild" \
  "fullProof_exact_continuation_and_blowup" \
  "fullProof_constructiveFaithfulLocalTheory"
do
  if ! rg -n "$pattern" "$FILE" >/dev/null; then
    echo "[check-fullproof-local-theory-derived] FAIL: missing $pattern" >&2
    exit 1
  fi
done

if rg -n "BaseAxiomPrimitiveExtensionWitness|extension_hypotheses|baseAxiom_localTheory_from_extensionWitness" "$FILE" >/dev/null; then
  echo "[check-fullproof-local-theory-derived] FAIL: found legacy extension-witness plumbing in full-proof local-theory route" >&2
  rg -n "BaseAxiomPrimitiveExtensionWitness|extension_hypotheses|baseAxiom_localTheory_from_extensionWitness" "$FILE" >&2
  exit 1
fi

BLOCK="$(rg -n -A12 "theorem clayBStatement_base_axiom_e2e" "$ENDPOINT_FILE" || true)"
if echo "$BLOCK" | rg -n "FaithfulMildLocalTheory" >/dev/null; then
  echo "[check-fullproof-local-theory-derived] FAIL: endpoint theorem still has explicit local-theory assumption handle" >&2
  exit 1
fi

echo "[check-fullproof-local-theory-derived] PASS"
