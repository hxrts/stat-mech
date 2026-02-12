#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful"
FILES=(
  "$TARGET_DIR/DecisiveSpineThreshold.lean"
  "$TARGET_DIR/DecisiveSpineProfile.lean"
  "$TARGET_DIR/DecisiveSpineMinimalElement.lean"
  "$TARGET_DIR/DecisiveSpineLocalEnergy.lean"
  "$TARGET_DIR/DecisiveSpineLowerMechanism.lean"
  "$TARGET_DIR/DecisiveSpineUpperMechanism.lean"
  "$TARGET_DIR/DecisiveSpineIncompatibility.lean"
  "$TARGET_DIR/DecisiveSpineGlobal.lean"
)

echo "[check-decisive-spine-frozen-setting-imports] checking decisive-spine imports"

for f in "${FILES[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "[check-decisive-spine-frozen-setting-imports] FAIL: missing file $f" >&2
    exit 1
  fi

  if ! rg -n '^import Gibbs\.ContinuumField\.NavierStokes\.Faithful\.DecisiveSpine' "$f" >/dev/null; then
    echo "[check-decisive-spine-frozen-setting-imports] FAIL: $f does not import decisive-spine frozen stack" >&2
    exit 1
  fi

done

EQ_FILE="$TARGET_DIR/DecisiveSpineClayEquivalence.lean"
if [[ ! -f "$EQ_FILE" ]]; then
  echo "[check-decisive-spine-frozen-setting-imports] FAIL: missing file $EQ_FILE" >&2
  exit 1
fi
if ! rg -n '^import Gibbs\.ContinuumField\.NavierStokes\.Faithful\.FullProofClayFinalization' "$EQ_FILE" >/dev/null; then
  echo "[check-decisive-spine-frozen-setting-imports] FAIL: $EQ_FILE must import full-proof finalization layer" >&2
  exit 1
fi

if rg -n --glob 'DecisiveSpine*.lean' '^import Gibbs\.ContinuumField\.NavierStokes\.Faithful\.(FullProofExactAnalysis|BaseAxiomAnalysis)$' "$TARGET_DIR" >/dev/null; then
  BAD="$(
    rg -n --glob 'DecisiveSpine*.lean' \
      '^import Gibbs\\.ContinuumField\\.NavierStokes\\.Faithful\\.(FullProofExactAnalysis|BaseAxiomAnalysis)$' \
      "$TARGET_DIR" | rg -v 'DecisiveSpineSetting\\.lean' || true
  )"
  if [[ -n "$BAD" ]]; then
    echo "[check-decisive-spine-frozen-setting-imports] FAIL: downstream decisive-spine files import alternate analysis roots directly" >&2
    echo "$BAD" >&2
    exit 1
  fi
fi

echo "[check-decisive-spine-frozen-setting-imports] PASS"
