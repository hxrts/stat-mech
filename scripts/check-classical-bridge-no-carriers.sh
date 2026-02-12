#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SEED_FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/SeedConstruction.lean"
SEM_FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomClassicalSemantics.lean"

echo "[check-classical-bridge-no-carriers] checking classical bridge carrier wrappers"

if rg -n 'structure\s+DecisiveSeedFromAnalysisTheorem\b' "$SEED_FILE" >/dev/null; then
  echo "[check-classical-bridge-no-carriers] FAIL: SeedConstruction still uses DecisiveSeedFromAnalysisTheorem carrier structure" >&2
  exit 1
fi

if rg -n '\bBaseAxiomClassicalObjectFamily\b' "$SEM_FILE" >/dev/null; then
  echo "[check-classical-bridge-no-carriers] FAIL: BaseAxiomClassicalSemantics still uses BaseAxiomClassicalObjectFamily alias carrier" >&2
  exit 1
fi

echo "[check-classical-bridge-no-carriers] PASS"
