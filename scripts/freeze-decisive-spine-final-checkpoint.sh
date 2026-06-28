#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/work/navier_decisive_spine_final_checkpoint.txt"
FILES=(
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveSpineSetting.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveSpineThreshold.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveSpineProfile.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveSpineMinimalElement.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveSpineLocalEnergy.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveSpineLowerMechanism.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveSpineUpperMechanism.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveSpineIncompatibility.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveSpineGlobal.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveSpineClayEquivalence.lean"
  "$ROOT/scripts/check-decisive-spine-frozen-setting-imports.sh"
  "$ROOT/scripts/check-decisive-spine-threshold-definition-first.sh"
  "$ROOT/scripts/check-decisive-spine-profile-derived.sh"
  "$ROOT/scripts/check-decisive-spine-minimal-element-derived.sh"
  "$ROOT/scripts/check-decisive-spine-local-energy-derived.sh"
  "$ROOT/scripts/check-decisive-spine-lower-upper-derived.sh"
  "$ROOT/scripts/check-decisive-spine-incompatibility.sh"
  "$ROOT/scripts/check-decisive-spine-global-derived.sh"
  "$ROOT/scripts/check-decisive-spine-clay-equivalence.sh"
  "$ROOT/scripts/report-decisive-spine-final-cone.sh"
)

for f in "${FILES[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "[freeze-decisive-spine-final-checkpoint] missing file: $f" >&2
    exit 1
  fi
done

HEAD_SHA="$(git -C "$ROOT" rev-parse HEAD 2>/dev/null || echo 'UNKNOWN')"
DIRTY_COUNT="$(git -C "$ROOT" status --porcelain | wc -l | tr -d ' ')"
NOW_UTC="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

{
  echo "# Decisive Spine Final Checkpoint"
  echo ""
  echo "Generated: $NOW_UTC"
  echo "Git HEAD: $HEAD_SHA"
  echo "Dirty entries at freeze time: $DIRTY_COUNT"
  echo ""
  echo "Command: just check-decisive-spine-proof-gate"
  echo ""
  echo "Files and SHA-256:"
  for f in "${FILES[@]}"; do
    rel="${f#${ROOT}/}"
    sha="$(shasum -a 256 "$f" | awk '{print $1}')"
    echo "- $rel"
    echo "  - $sha"
  done
} > "$OUT"

echo "[freeze-decisive-spine-final-checkpoint] wrote $OUT"
