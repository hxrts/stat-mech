#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/FullProofExactGlobal.lean"

echo "[check-fullproof-global-derived] checking global derivation route"

for pattern in \
  "fullProof_noMinimal_implies_globalControl" \
  "fullProof_longTime_continuation_globalExtension" \
  "fullProof_smoothness_persistence" \
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

if rg -n "^theorem fullProof_noMinimal_implies_globalControl_direct\\b|^theorem fullProof_longTime_continuation_globalExtension_direct\\b|^theorem fullProof_smoothness_persistence_direct\\b|^theorem fullProof_exact_faithfulHardGlobalClosure_direct\\b" "$FILE" >/dev/null; then
  echo "[check-fullproof-global-derived] FAIL: retired full-proof global direct wrappers reintroduced" >&2
  rg -n "^theorem fullProof_noMinimal_implies_globalControl_direct\\b|^theorem fullProof_longTime_continuation_globalExtension_direct\\b|^theorem fullProof_smoothness_persistence_direct\\b|^theorem fullProof_exact_faithfulHardGlobalClosure_direct\\b" "$FILE" >&2
  exit 1
fi

EXT_BLOCK="$(
  awk '
    /theorem fullProof_longTime_continuation_globalExtension$/ {flag=1}
    flag {print}
    flag && /^\/-! ## Smoothness persistence -\// {exit}
  ' "$FILE"
)"
if [[ -z "$EXT_BLOCK" ]]; then
  echo "[check-fullproof-global-derived] FAIL: missing long-time continuation block" >&2
  exit 1
fi
if ! echo "$EXT_BLOCK" | rg -n "baseAxiom_global_extension_from_continuation" >/dev/null; then
  echo "[check-fullproof-global-derived] FAIL: continuation theorem is not routed through baseAxiom_global_extension_from_continuation" >&2
  exit 1
fi

SMOOTH_BLOCK="$(
  awk '
    /theorem fullProof_smoothness_persistence$/ {flag=1}
    flag {print}
    flag && /^\/-! ## Faithful hard-global closure -\// {exit}
  ' "$FILE"
)"
if [[ -z "$SMOOTH_BLOCK" ]]; then
  echo "[check-fullproof-global-derived] FAIL: missing smoothness block" >&2
  exit 1
fi
if ! echo "$SMOOTH_BLOCK" | rg -n "fullProof_longTime_continuation_globalExtension" >/dev/null; then
  echo "[check-fullproof-global-derived] FAIL: smoothness theorem is not routed through fullProof_longTime_continuation_globalExtension" >&2
  exit 1
fi

CLOSURE_BLOCK="$(
  awk '
    /theorem fullProof_exact_faithfulHardGlobalClosure$/ {flag=1}
    flag {print}
    flag && /^\/-! ## Policy markers -\// {exit}
  ' "$FILE"
)"
if [[ -z "$CLOSURE_BLOCK" ]]; then
  echo "[check-fullproof-global-derived] FAIL: missing faithful hard-global closure block" >&2
  exit 1
fi
if ! echo "$CLOSURE_BLOCK" | rg -n "fullProof_longTime_continuation_globalExtension" >/dev/null; then
  echo "[check-fullproof-global-derived] FAIL: faithful hard-global closure theorem is not routed through fullProof_longTime_continuation_globalExtension" >&2
  exit 1
fi

echo "[check-fullproof-global-derived] PASS"
