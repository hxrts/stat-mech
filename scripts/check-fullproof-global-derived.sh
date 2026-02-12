#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/FullProofExactGlobal.lean"

echo "[check-fullproof-global-derived] checking global derivation route"

for pattern in \
  "fullProof_noMinimal_implies_globalControl_direct" \
  "fullProof_noMinimal_implies_globalControl" \
  "fullProof_longTime_continuation_globalExtension_direct" \
  "fullProof_longTime_continuation_globalExtension" \
  "fullProof_smoothness_persistence_direct" \
  "fullProof_smoothness_persistence" \
  "fullProof_exact_faithfulHardGlobalClosure_direct" \
  "fullProof_exact_faithfulHardGlobalClosure"
do
  if ! rg -n "$pattern" "$FILE" >/dev/null; then
    echo "[check-fullproof-global-derived] FAIL: missing $pattern" >&2
    exit 1
  fi
done

if rg -n 'vel\s*:=\s*fun _ =>|press\s*:=\s*fun _ =>|dvel\s*:=\s*fun _ =>' "$FILE" >/dev/null; then
  echo "[check-fullproof-global-derived] FAIL: found direct formula injection in full-proof global file" >&2
  exit 1
fi

if rg -n "BaseAxiomPrimitiveExtensionWitness|extension_hypotheses" "$FILE" >/dev/null; then
  echo "[check-fullproof-global-derived] FAIL: found legacy extension-witness plumbing in full-proof global file" >&2
  exit 1
fi

echo "[check-fullproof-global-derived] PASS"
