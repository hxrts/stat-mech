#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FINAL_FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveCompletion.lean"
OUT="$ROOT/work/navier_decisive_hardstep_report.txt"

{
  echo "# Decisive Hard-Step Cone Report"
  echo ""
  echo "Generated: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo "Primary theorem handle: Gibbs.ContinuumField.NavierStokes.clayBStatement_from_decisive_completion"
  echo "Primary theorem file: Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveCompletion.lean"
  echo ""
  echo "## Import Cone (Decisive Completion)"
  rg '^import Gibbs\.ContinuumField\.NavierStokes\.' "$FINAL_FILE" | sed 's/^import /- /'
  echo ""
  echo "## Required Gates"
  echo "- lake build Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveCompletion"
  echo "- bash ./scripts/check-faithful-clayb-cone.sh"
  echo "- bash ./scripts/check-decisive-hardstep-cone.sh"
} > "$OUT"

echo "[report-decisive-hardstep-cone] wrote $OUT"

