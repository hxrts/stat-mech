#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FAC="$ROOT/Gibbs/ContinuumField/NavierStokes.lean"
OUT="$ROOT/work/navier_clayb_cone_report.txt"

{
  echo "# Clay(B) Dependency Cone Report"
  echo ""
  echo "Generated: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo "Primary theorem handle: Gibbs.ContinuumField.NavierStokes.clayBStatement_unconditional_no_bridge"
  echo "Primary theorem file: Gibbs/ContinuumField/NavierStokes/HardStep/Definitive/TrueTorusClayBUnconditional.lean"
  echo ""
  echo "## Facade Import Cone (NavierStokes)"
  rg '^import Gibbs\.ContinuumField\.NavierStokes\.' "$FAC" \
    | sed 's/^import /- /'
  echo ""
  echo "## Required Gates"
  echo "- lake build Gibbs.ContinuumField.NavierStokes"
  echo "- bash ./scripts/check-navier-final-cone-placeholders.sh"
  echo "- bash ./scripts/check-clayb-cone-no-axiom-sorry.sh"
} > "$OUT"

echo "[report-clayb-dependency-cone] wrote $OUT"

