#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/BaseAxiomGlobal.lean"

echo "[check-base-axiom-extension-derived-route] checking derived extension route in $FILE"

for pattern in \
  "baseAxiom_unconditional_global_control" \
  "baseAxiom_global_extension_from_continuation" \
  "baseAxiom_global_extension_from_primitive_contradiction" \
  "baseAxiom_global_strong_solution_extension" \
  "FaithfulMildLocalTheory" \
  "baseAxiom_faithfulHardGlobalClosure_constructive"
do
  if ! rg -n "$pattern" "$FILE" >/dev/null; then
    echo "[check-base-axiom-extension-derived-route] FAIL: missing $pattern" >&2
    exit 1
  fi
done

if ! rg -n "HardStepGlobalClosure" "$FILE" >/dev/null; then
  echo "[check-base-axiom-extension-derived-route] FAIL: direct closure-hypothesis route not found" >&2
  exit 1
fi

if rg -n "BaseAxiomPrimitiveContinuationOutput|global_control_from_rigidity|global_extension\s*:" "$FILE" >/dev/null; then
  echo "[check-base-axiom-extension-derived-route] FAIL: found legacy continuation-carrier fields" >&2
  exit 1
fi

if rg -n "baseAxiomConstructedStrongSolution" "$FILE" >/dev/null; then
  echo "[check-base-axiom-extension-derived-route] FAIL: found synthetic constructed-solution dependency in base-axiom global route" >&2
  exit 1
fi

if rg -n "baseAxiom_constructiveLocalTheory" "$FILE" >/dev/null; then
  echo "[check-base-axiom-extension-derived-route] FAIL: found synthetic local-theory constructor dependency in base-axiom global route" >&2
  exit 1
fi

if rg -n "BaseAxiomPrimitiveExtensionWitness|extension_hypotheses" "$FILE" >/dev/null; then
  echo "[check-base-axiom-extension-derived-route] FAIL: found legacy extension-witness plumbing in base-axiom global route" >&2
  exit 1
fi

if rg -n "^theorem baseAxiom_unconditional_global_control_direct\\b|^theorem baseAxiom_global_extension_from_continuation_direct\\b|^theorem baseAxiom_global_extension_from_primitive_contradiction_direct\\b|^theorem baseAxiom_global_strong_solution_extension_direct\\b|^theorem baseAxiom_faithfulHardGlobalClosure_constructive_direct\\b" "$FILE" >/dev/null; then
  echo "[check-base-axiom-extension-derived-route] FAIL: retired base-axiom global direct wrappers reintroduced" >&2
  rg -n "^theorem baseAxiom_unconditional_global_control_direct\\b|^theorem baseAxiom_global_extension_from_continuation_direct\\b|^theorem baseAxiom_global_extension_from_primitive_contradiction_direct\\b|^theorem baseAxiom_global_strong_solution_extension_direct\\b|^theorem baseAxiom_faithfulHardGlobalClosure_constructive_direct\\b" "$FILE" >&2
  exit 1
fi

CONT_BLOCK="$(rg -n -A30 "theorem baseAxiom_global_extension_from_primitive_contradiction" "$FILE" || true)"
if [[ -z "$CONT_BLOCK" ]]; then
  echo "[check-base-axiom-extension-derived-route] FAIL: primitive contradiction extension theorem block missing" >&2
  exit 1
fi

if ! echo "$CONT_BLOCK" | rg -n "baseAxiom_global_extension_from_continuation" >/dev/null; then
  echo "[check-base-axiom-extension-derived-route] FAIL: contradiction extension theorem is not routed through continuation theorem" >&2
  exit 1
fi

BLOCK="$(rg -n -A30 "theorem baseAxiom_global_strong_solution_extension" "$FILE" || true)"
if [[ -z "$BLOCK" ]]; then
  echo "[check-base-axiom-extension-derived-route] FAIL: global extension theorem block missing" >&2
  exit 1
fi

if ! echo "$BLOCK" | rg -n "baseAxiom_global_extension_from_primitive_contradiction" >/dev/null; then
  echo "[check-base-axiom-extension-derived-route] FAIL: global extension theorem is not routed through contradiction-derived extension" >&2
  exit 1
fi

echo "[check-base-axiom-extension-derived-route] PASS"
