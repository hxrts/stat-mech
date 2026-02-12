#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful"

echo "[check-decisive-hardstep-cone] scanning $TARGET_DIR"

if rg -n --glob '*.lean' '^\s*(axiom|sorry)\b' "$TARGET_DIR"; then
  echo "[check-decisive-hardstep-cone] FAIL: found axiom/sorry"
  exit 1
fi

echo "[check-decisive-hardstep-cone] PASS"

