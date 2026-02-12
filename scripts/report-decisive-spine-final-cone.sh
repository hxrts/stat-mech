#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/work/navier_decisive_spine_final_cone_report.txt"
FILES=(
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveSpineSetting.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveSpineThreshold.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveSpineProfile.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveSpineMinimalElement.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveSpineLocalEnergy.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveSpineLowerMechanism.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveSpineUpperMechanism.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveSpineIncompatibility.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveSpineGlobal.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveSpineClayEquivalence.lean"
)

{
  echo "# Decisive Spine Final Cone Report"
  echo ""
  echo "Generated: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo "Primary theorem handle: Gibbs.ContinuumField.NavierStokes.decisiveSpine_clayB_equivalence"
  echo "Primary theorem file: Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveSpineClayEquivalence.lean"
  echo ""
  echo "## Imports"
  for f in "${FILES[@]}"; do
    rel="${f#${ROOT}/}"
    echo ""
    echo "### $rel"
    rg '^import Gibbs\.ContinuumField\.NavierStokes\.' "$f" | sed 's/^import /- /'
  done
  echo ""
  echo "## Required Gates"
  echo "- just check-fullproof-clay-proof-gate"
  echo "- bash ./scripts/check-decisive-spine-frozen-setting-imports.sh"
  echo "- bash ./scripts/check-decisive-spine-threshold-definition-first.sh"
  echo "- bash ./scripts/check-decisive-spine-profile-derived.sh"
  echo "- bash ./scripts/check-decisive-spine-minimal-element-derived.sh"
  echo "- bash ./scripts/check-decisive-spine-local-energy-derived.sh"
  echo "- bash ./scripts/check-decisive-spine-lower-upper-derived.sh"
  echo "- bash ./scripts/check-decisive-spine-incompatibility.sh"
  echo "- bash ./scripts/check-decisive-spine-global-derived.sh"
  echo "- bash ./scripts/check-decisive-spine-clay-equivalence.sh"
} > "$OUT"

echo "[report-decisive-spine-final-cone] wrote $OUT"
