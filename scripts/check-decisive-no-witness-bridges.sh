#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful"

echo "[check-decisive-no-witness-bridges] scanning $TARGET"

if rg -n \
  'DecisiveSpineLowerWitnessFamily|DecisiveSpineUpperWitnessFamily|decisiveSpine_flux_hypotheses_derived|decisiveGlobalClosureTheorem_from_witnesses|DecisiveSpineConstructiveWitnessFamily|decisiveSpine_constructive_flux_hypotheses_of_witness_family|decisiveGlobalClosureTheorem_constructive_of_witness_hypotheses|decisiveSpine_incompatibility_from_witness' \
  "$TARGET" >/dev/null; then
  echo "[check-decisive-no-witness-bridges] FAIL: found retired decisive witness-bridge symbol(s)" >&2
  rg -n \
    'DecisiveSpineLowerWitnessFamily|DecisiveSpineUpperWitnessFamily|decisiveSpine_flux_hypotheses_derived|decisiveGlobalClosureTheorem_from_witnesses|DecisiveSpineConstructiveWitnessFamily|decisiveSpine_constructive_flux_hypotheses_of_witness_family|decisiveGlobalClosureTheorem_constructive_of_witness_hypotheses|decisiveSpine_incompatibility_from_witness' \
    "$TARGET" >&2
  exit 1
fi

echo "[check-decisive-no-witness-bridges] PASS"
