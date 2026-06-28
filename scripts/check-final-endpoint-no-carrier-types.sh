#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILES=(
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/BaseAxiomCompletion.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/FullProofClayFinalization.lean"
  "$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveSpineClayEquivalence.lean"
)

echo "[check-final-endpoint-no-carrier-types] checking final endpoint cone"

PATTERN='BaseAxiomPrimitiveCompactness|BaseAxiomPrimitiveRigidity|BaseAxiomPrimitiveExtensionWitness|BaseAxiomPrimitiveGlobalData|FullProofExactGlobalData|DecisiveSpineGlobalRoute|BaseAxiomClassicalObject|BaseAxiomClassicalObjectFamily|BaseAxiomEndpointInput|BaseAxiomEndpointFamily'

for f in "${FILES[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "[check-final-endpoint-no-carrier-types] FAIL: missing file $f" >&2
    exit 1
  fi
  if rg -n "$PATTERN" "$f" >/dev/null; then
    echo "[check-final-endpoint-no-carrier-types] FAIL: carrier types found in $f" >&2
    rg -n "$PATTERN" "$f" >&2
    exit 1
  fi
done

echo "[check-final-endpoint-no-carrier-types] PASS"
