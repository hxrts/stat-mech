#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/BaseAxiomCompletion.lean"

echo "[check-base-axiom-no-local-theory-handle] checking endpoint theorem signature in $FILE"

BLOCK="$(rg -n -A12 "theorem clayBStatement_base_axiom_e2e" "$FILE" || true)"
if [[ -z "$BLOCK" ]]; then
  echo "[check-base-axiom-no-local-theory-handle] FAIL: endpoint theorem not found" >&2
  exit 1
fi

if echo "$BLOCK" | rg -n "FaithfulMildLocalTheory" >/dev/null; then
  echo "[check-base-axiom-no-local-theory-handle] FAIL: endpoint theorem still takes local-theory assumption handles" >&2
  exit 1
fi

echo "[check-base-axiom-no-local-theory-handle] PASS"
