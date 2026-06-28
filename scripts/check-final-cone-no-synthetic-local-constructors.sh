#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILES=(
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/BaseAxiomLocalTheory.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/FullProofExactLocalTheory.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/BaseAxiomGlobal.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/FullProofExactGlobal.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveSpineGlobal.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/BaseAxiomCompletion.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/FullProofClayFinalization.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveSpineClayEquivalence.lean"
)

PATTERN='baseAxiomConstructedStrongSolution|baseAxiom_constructiveLocalTheory'

echo "[check-final-cone-no-synthetic-local-constructors] checking final cone"

for f in "${FILES[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "[check-final-cone-no-synthetic-local-constructors] FAIL: missing file $f" >&2
    exit 1
  fi
  if rg -n "$PATTERN" "$f" >/dev/null; then
    echo "[check-final-cone-no-synthetic-local-constructors] FAIL: synthetic local constructor found in $f" >&2
    rg -n "$PATTERN" "$f" >&2
    exit 1
  fi
done

echo "[check-final-cone-no-synthetic-local-constructors] PASS"
