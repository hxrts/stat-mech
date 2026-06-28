#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/work/navier_fullproof_final_cone_report.txt"
FILES=(
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/FullProofExactAnalysis.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/FullProofExactLocalTheory.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/FullProofExactCompactness.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/FullProofExactRigidity.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/FullProofExactGlobal.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/FullProofClayFinalization.lean"
)

{
  echo "# Full-Proof Final Cone Report"
  echo ""
  echo "Generated: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo "Primary theorem handle: StatMech.ContinuumField.NavierStokes.fullProof_clayQuantifier_equivalence"
  echo "Primary theorem file: StatMech/ContinuumField/NavierStokes/Faithful/FullProofClayFinalization.lean"
  echo ""
  echo "## Imports"
  for f in "${FILES[@]}"; do
    rel="${f#${ROOT}/}"
    echo ""
    echo "### $rel"
    rg '^import StatMech\.ContinuumField\.NavierStokes\.' "$f" | sed 's/^import /- /'
  done
  echo ""
  echo "## Required Gates"
  echo "- just check-base-axiom-definitive-readiness"
  echo "- bash ./scripts/check-fullproof-no-simplified-standins.sh"
  echo "- bash ./scripts/check-fullproof-local-theory-derived.sh"
  echo "- bash ./scripts/check-fullproof-compactness-derived.sh"
  echo "- bash ./scripts/check-fullproof-rigidity-derived.sh"
  echo "- bash ./scripts/check-fullproof-global-derived.sh"
  echo "- bash ./scripts/check-fullproof-final-audit.sh"
} > "$OUT"

echo "[report-fullproof-final-cone] wrote $OUT"
