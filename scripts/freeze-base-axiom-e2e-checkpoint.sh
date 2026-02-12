#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/work/navier_base_axiom_e2e_checkpoint.txt"
FILES=(
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomAnalysis.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomLocalTheory.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomCompactness.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomRigidity.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomGlobal.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomCompletion.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomClassicalSemantics.lean"
)

for f in "${FILES[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "[freeze-base-axiom-e2e-checkpoint] missing theorem file: $f" >&2
    exit 1
  fi
done

HEAD_SHA="$(git -C "$ROOT" rev-parse HEAD 2>/dev/null || echo 'UNKNOWN')"
DIRTY_COUNT="$(git -C "$ROOT" status --porcelain | wc -l | tr -d ' ')"
NOW_UTC="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

{
  echo "# Base-Axiom E2E Checkpoint"
  echo ""
  echo "Generated: $NOW_UTC"
  echo "Git HEAD: $HEAD_SHA"
  echo "Dirty entries at freeze time: $DIRTY_COUNT"
  echo ""
  echo "Files and SHA-256:"
  for f in "${FILES[@]}"; do
    rel="${f#${ROOT}/}"
    sha="$(shasum -a 256 "$f" | awk '{print $1}')"
    echo "- $rel"
    echo "  - $sha"
  done
} > "$OUT"

echo "[freeze-base-axiom-e2e-checkpoint] wrote $OUT"
