#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomGlobal.lean"

echo "[check-base-axiom-extension-derived-route] checking derived extension route in $FILE"

for pattern in \
  "baseAxiom_unconditional_global_control_direct" \
  "baseAxiom_global_extension_from_continuation_direct" \
  "baseAxiom_global_extension_from_primitive_contradiction_direct" \
  "baseAxiom_global_extension_from_primitive_contradiction" \
  "baseAxiom_global_strong_solution_extension_direct" \
  "baseAxiom_global_strong_solution_extension" \
  "baseAxiom_faithfulHardGlobalClosure_constructive_direct" \
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

BLOCK="$(rg -n -A10 "theorem baseAxiom_global_strong_solution_extension" "$FILE" || true)"
if [[ -z "$BLOCK" ]]; then
  echo "[check-base-axiom-extension-derived-route] FAIL: global extension theorem block missing" >&2
  exit 1
fi

if ! echo "$BLOCK" | rg -n "baseAxiom_global_extension_from_primitive_contradiction" >/dev/null; then
  echo "[check-base-axiom-extension-derived-route] FAIL: global extension theorem is not routed through contradiction-derived extension" >&2
  exit 1
fi

echo "[check-base-axiom-extension-derived-route] PASS"
