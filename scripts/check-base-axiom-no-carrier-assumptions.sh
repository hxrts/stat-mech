#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful"

echo "[check-base-axiom-no-carrier-assumptions] scanning base-axiom files"

if rg -n --glob 'BaseAxiom*.lean' \
  'BaseAxiomPrimitiveContinuationOutput|global_control_from_rigidity|global_extension\s*:|localTheory\s*:\s*FaithfulMildLocalTheory|globalData\s*:\s*BaseAxiomPrimitiveGlobalData|BaseAxiomPrimitiveExtensionWitness|extension_hypotheses' \
  "$TARGET_DIR" >/dev/null; then
  echo "[check-base-axiom-no-carrier-assumptions] FAIL: found legacy carrier-assumption fields in base-axiom cone" >&2
  exit 1
fi

echo "[check-base-axiom-no-carrier-assumptions] PASS"
