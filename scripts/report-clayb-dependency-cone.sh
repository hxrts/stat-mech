#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FAC="$ROOT/StatMech/ContinuumField/NavierStokes.lean"
OUT="$ROOT/work/navier_clayb_cone_report.txt"

{
  echo "# Clay(B) Dependency Cone Report"
  echo ""
  echo "Generated: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo "Primary theorem handle: StatMech.ContinuumField.NavierStokes.clayBStatement_base_axiom_e2e"
  echo "Primary theorem file: StatMech/ContinuumField/NavierStokes/Faithful/BaseAxiomCompletion.lean"
  echo ""
  echo "## Facade Import Cone (NavierStokes)"
  rg '^import StatMech\.ContinuumField\.NavierStokes\.' "$FAC" \
    | sed 's/^import /- /'
  echo ""
  echo "## Required Gates"
  echo "- lake build StatMech.ContinuumField.NavierStokes"
  echo "- bash ./scripts/check-navier-final-cone-placeholders.sh"
  echo "- bash ./scripts/check-navier-final-no-shortcut-route.sh"
  echo "- bash ./scripts/check-navier-final-no-trivial-smoothness.sh"
  echo "- bash ./scripts/check-clayb-cone-no-axiom-sorry.sh"
} > "$OUT"

echo "[report-clayb-dependency-cone] wrote $OUT"
