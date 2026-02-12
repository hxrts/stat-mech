#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful"

echo "[check-faithful-smoothness-fidelity] scanning $TARGET_DIR"

if rg -n --glob '*.lean' 'smoothVelocity\s*:=\s*fun _ => True|smoothPressure\s*:=\s*fun _ => True' "$TARGET_DIR"; then
  echo "[check-faithful-smoothness-fidelity] FAIL: found placeholder smoothness assignments" >&2
  exit 1
fi

if ! rg -n --glob '*.lean' 'FaithfulSmoothnessRegularityBridge|condition11_of_faithful_regular_certification' "$TARGET_DIR" >/dev/null; then
  echo "[check-faithful-smoothness-fidelity] FAIL: missing smoothness-regularity bridge theorems" >&2
  exit 1
fi

echo "[check-faithful-smoothness-fidelity] PASS"
