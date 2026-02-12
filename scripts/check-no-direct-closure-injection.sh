#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GLOBAL_FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveGlobal.lean"
HARDSTEP_FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/TrueHardStep.lean"

echo "[check-no-direct-closure-injection] scanning $GLOBAL_FILE and $HARDSTEP_FILE"

if rg -n 'vel\s*:=\s*fun _ =>|press\s*:=\s*fun _ =>|dvel\s*:=\s*fun _ =>' "$GLOBAL_FILE" "$HARDSTEP_FILE"; then
  echo "[check-no-direct-closure-injection] FAIL: found direct closed-form solution injection in decisive closure route" >&2
  exit 1
fi

if rg -n 'hardStepConstructedGlobalSolution|hardStepGlobalControl_constructive' "$HARDSTEP_FILE"; then
  echo "[check-no-direct-closure-injection] FAIL: found synthetic hard-step global-solution constructor route" >&2
  exit 1
fi

if ! rg -n 'hardStepGlobalControl_from_contradiction_route|hardStep_global_extension_from_continuation_route' "$HARDSTEP_FILE" >/dev/null; then
  echo "[check-no-direct-closure-injection] FAIL: missing theorem-derived hard-step continuation/extension route" >&2
  exit 1
fi

echo "[check-no-direct-closure-injection] PASS"
