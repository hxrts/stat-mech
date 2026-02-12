#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/work/navier_base_axiom_e2e_report.txt"
FILES=(
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomAnalysis.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomLocalTheory.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomCompactness.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomRigidity.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomGlobal.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomCompletion.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomClassicalSemantics.lean"
)

{
  echo "# Base-Axiom E2E Cone Report"
  echo ""
  echo "Generated: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo "Primary theorem handle: Gibbs.ContinuumField.NavierStokes.clayBStatement_base_axiom_e2e"
  echo "Primary theorem file: Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomCompletion.lean"
  echo ""
  echo "## Import Cone (Base-Axiom Route)"
  for f in "${FILES[@]}"; do
    rel="${f#${ROOT}/}"
    echo ""
    echo "### $rel"
    rg '^import Gibbs\.ContinuumField\.NavierStokes\.' "$f" | sed 's/^import /- /'
  done
  echo ""
  echo "## Required Gates"
  echo "- lake build Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomCompletion"
  echo "- bash ./scripts/check-base-axiom-no-package-assumptions.sh"
  echo "- bash ./scripts/check-base-axiom-primitive-imports.sh"
  echo "- bash ./scripts/check-no-direct-closure-injection.sh"
} > "$OUT"

echo "[report-base-axiom-e2e-cone] wrote $OUT"
