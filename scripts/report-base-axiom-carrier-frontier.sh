#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/work/navier_base_axiom_carrier_frontier.txt"
FILES=(
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomAnalysis.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomLocalTheory.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomCompactness.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomRigidity.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomGlobal.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomCompletion.lean"
)

{
  echo "# Base-Axiom Carrier Frontier Report"
  echo ""
  echo "Generated: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo ""
  for f in "${FILES[@]}"; do
    rel="${f#${ROOT}/}"
    echo "## $rel"
    echo ""
    echo "### structure declarations"
    rg -n '^structure ' "$f" || true
    echo ""
    echo "### fields with : Prop"
    rg -n '^\s+[A-Za-z0-9_]+\s*:\s*Prop' "$f" || true
    echo ""
    echo "### fields/theorems with arrow-heavy assumptions"
    rg -n '^\s+[A-Za-z0-9_]+\s*:\s*.*→.*' "$f" || true
    echo ""
  done
} > "$OUT"

echo "[report-base-axiom-carrier-frontier] wrote $OUT"
