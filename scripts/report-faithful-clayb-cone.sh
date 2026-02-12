#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FINAL_FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/Final.lean"
OUT="$ROOT/work/navier_faithful_cone_report.txt"

{
  echo "# Faithful Clay(B) Dependency Cone Report"
  echo ""
  echo "Generated: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo "Primary theorem handle: Gibbs.ContinuumField.NavierStokes.FaithfulClayBStatement"
  echo "Primary theorem file: Gibbs/ContinuumField/NavierStokes/Faithful/Final.lean"
  echo ""
  echo "## Import Cone (Faithful Final)"
  rg '^import Gibbs\.ContinuumField\.NavierStokes\.' "$FINAL_FILE" | sed 's/^import /- /'
  echo ""
  echo "## Required Gates"
  echo "- lake build Gibbs.ContinuumField.NavierStokes.Faithful.Final"
  echo "- bash ./scripts/check-faithful-clayb-cone.sh"
  echo "- bash ./scripts/check-clayb-cone-no-axiom-sorry.sh"
} > "$OUT"

echo "[report-faithful-clayb-cone] wrote $OUT"

