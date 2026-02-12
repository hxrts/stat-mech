#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/work/navier_base_axiom_definitive_readiness_checkpoint.txt"
FILES=(
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomAnalysis.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomLocalTheory.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomCompactness.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomRigidity.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomGlobal.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomCompletion.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomClassicalSemantics.lean"
  "$ROOT/scripts/check-base-axiom-no-package-assumptions.sh"
  "$ROOT/scripts/check-base-axiom-primitive-imports.sh"
  "$ROOT/scripts/check-base-axiom-no-definitive-shortcuts.sh"
  "$ROOT/scripts/check-base-axiom-no-shortcut-cone.sh"
  "$ROOT/scripts/check-base-axiom-compactness-imports.sh"
  "$ROOT/scripts/check-base-axiom-rigidity-imports.sh"
  "$ROOT/scripts/check-base-axiom-no-direct-injection.sh"
  "$ROOT/scripts/check-base-axiom-no-local-theory-handle.sh"
  "$ROOT/scripts/check-base-axiom-extension-derived-route.sh"
  "$ROOT/scripts/check-base-axiom-no-carrier-assumptions.sh"
  "$ROOT/scripts/check-base-axiom-cone-no-axiom-sorry.sh"
  "$ROOT/scripts/report-base-axiom-carrier-frontier.sh"
  "$ROOT/scripts/report-base-axiom-e2e-cone.sh"
  "$ROOT/scripts/report-base-axiom-no-shortcut-cone.sh"
)

for f in "${FILES[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "[freeze-base-axiom-definitive-readiness-checkpoint] missing file: $f" >&2
    exit 1
  fi
done

HEAD_SHA="$(git -C "$ROOT" rev-parse HEAD 2>/dev/null || echo 'UNKNOWN')"
DIRTY_COUNT="$(git -C "$ROOT" status --porcelain | wc -l | tr -d ' ')"
NOW_UTC="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

{
  echo "# Base-Axiom Definitive Readiness Checkpoint"
  echo ""
  echo "Generated: $NOW_UTC"
  echo "Git HEAD: $HEAD_SHA"
  echo "Dirty entries at freeze time: $DIRTY_COUNT"
  echo ""
  echo "Command: just check-base-axiom-definitive-readiness"
  echo ""
  echo "Files and SHA-256:"
  for f in "${FILES[@]}"; do
    rel="${f#${ROOT}/}"
    sha="$(shasum -a 256 "$f" | awk '{print $1}')"
    echo "- $rel"
    echo "  - $sha"
  done
} > "$OUT"

echo "[freeze-base-axiom-definitive-readiness-checkpoint] wrote $OUT"
