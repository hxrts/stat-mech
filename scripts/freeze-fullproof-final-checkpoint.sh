#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/work/navier_fullproof_final_checkpoint.txt"
FILES=(
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/FullProofExactAnalysis.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/FullProofExactLocalTheory.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/FullProofExactCompactness.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/FullProofExactRigidity.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/FullProofExactGlobal.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/FullProofClayFinalization.lean"
  "$ROOT/scripts/check-fullproof-no-simplified-standins.sh"
  "$ROOT/scripts/check-fullproof-local-theory-derived.sh"
  "$ROOT/scripts/check-fullproof-compactness-derived.sh"
  "$ROOT/scripts/check-fullproof-rigidity-derived.sh"
  "$ROOT/scripts/check-fullproof-global-derived.sh"
  "$ROOT/scripts/check-fullproof-final-audit.sh"
  "$ROOT/scripts/report-fullproof-final-cone.sh"
)

for f in "${FILES[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "[freeze-fullproof-final-checkpoint] missing file: $f" >&2
    exit 1
  fi
done

HEAD_SHA="$(git -C "$ROOT" rev-parse HEAD 2>/dev/null || echo 'UNKNOWN')"
DIRTY_COUNT="$(git -C "$ROOT" status --porcelain | wc -l | tr -d ' ')"
NOW_UTC="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

{
  echo "# Full-Proof Final Checkpoint"
  echo ""
  echo "Generated: $NOW_UTC"
  echo "Git HEAD: $HEAD_SHA"
  echo "Dirty entries at freeze time: $DIRTY_COUNT"
  echo ""
  echo "Command: just check-fullproof-clay-proof-gate"
  echo ""
  echo "Files and SHA-256:"
  for f in "${FILES[@]}"; do
    rel="${f#${ROOT}/}"
    sha="$(shasum -a 256 "$f" | awk '{print $1}')"
    echo "- $rel"
    echo "  - $sha"
  done
} > "$OUT"

echo "[freeze-fullproof-final-checkpoint] wrote $OUT"
