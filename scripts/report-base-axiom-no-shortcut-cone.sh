#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful"
OUT="$ROOT/work/navier_base_axiom_no_shortcut_cone.txt"

FILES=(
  "$TARGET_DIR/BaseAxiomAnalysis.lean"
  "$TARGET_DIR/BaseAxiomLocalTheory.lean"
  "$TARGET_DIR/BaseAxiomCompactness.lean"
  "$TARGET_DIR/BaseAxiomRigidity.lean"
  "$TARGET_DIR/BaseAxiomGlobal.lean"
  "$TARGET_DIR/BaseAxiomCompletion.lean"
  "$TARGET_DIR/BaseAxiomClassicalSemantics.lean"
)

{
  echo "# Base-Axiom No-Shortcut Cone Report"
  echo ""
  echo "Generated: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo ""
  echo "## Imports"
  for f in "${FILES[@]}"; do
    rel="${f#${ROOT}/}"
    echo ""
    echo "### $rel"
    rg '^import Gibbs\.ContinuumField\.NavierStokes\.' "$f" | sed 's/^import /- /'
  done
  echo ""
  echo "## Banned shortcut modules"
  echo "- Gibbs.ContinuumField.NavierStokes.Global.ClayEndgame"
  echo "- Gibbs.ContinuumField.NavierStokes.HardStep.Definitive.TrueTorusClayBUnconditional"
  echo "- Gibbs.ContinuumField.NavierStokes.HardStep.Definitive.TrueTorusFluxBarrier"
} > "$OUT"

echo "[report-base-axiom-no-shortcut-cone] wrote $OUT"
