#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GLOBAL_FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveGlobal.lean"
COMP_FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveCompletion.lean"

echo "[check-decisive-kernel-no-carriers] checking decisive kernel carrier structures"

if rg -n 'structure\s+DecisiveGlobalClosureTheorem\b' "$GLOBAL_FILE" >/dev/null; then
  echo "[check-decisive-kernel-no-carriers] FAIL: DecisiveGlobalClosureTheorem structure still present" >&2
  exit 1
fi

if rg -n 'structure\s+DecisiveCompletionSeed\b' "$COMP_FILE" >/dev/null; then
  echo "[check-decisive-kernel-no-carriers] FAIL: DecisiveCompletionSeed structure still present" >&2
  exit 1
fi

if rg -n '\bDecisiveGlobalClosureTheorem\b|\bDecisiveCompletionSeed\b' "$GLOBAL_FILE" "$COMP_FILE" >/dev/null; then
  echo "[check-decisive-kernel-no-carriers] FAIL: residual carrier type names remain in decisive kernel files" >&2
  rg -n '\bDecisiveGlobalClosureTheorem\b|\bDecisiveCompletionSeed\b' "$GLOBAL_FILE" "$COMP_FILE" >&2
  exit 1
fi

echo "[check-decisive-kernel-no-carriers] PASS"
