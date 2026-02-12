#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/ClassicalEquivalence.lean"
OUT="$ROOT/work/navier_classical_equivalence_report.txt"

{
  echo "# Classical-Equivalence Cone Report"
  echo ""
  echo "Generated: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo "Primary theorem handle: Gibbs.ContinuumField.NavierStokes.clayBStatement_classical_equivalent_route"
  echo "Primary theorem file: Gibbs/ContinuumField/NavierStokes/Faithful/ClassicalEquivalence.lean"
  echo ""
  echo "## Import Cone (Classical Equivalence)"
  rg '^import Gibbs\.ContinuumField\.NavierStokes\.' "$FILE" | sed 's/^import /- /'
  echo ""
  echo "## Required Gates"
  echo "- lake build Gibbs.ContinuumField.NavierStokes.Faithful.ClassicalEquivalence"
  echo "- bash ./scripts/check-decisive-no-seed-family.sh"
  echo "- bash ./scripts/check-faithful-smoothness-fidelity.sh"
  echo "- bash ./scripts/check-hardstep-quantitative-route.sh"
  echo "- bash ./scripts/check-no-direct-closure-injection.sh"
} > "$OUT"

echo "[report-classical-equivalence-cone] wrote $OUT"
