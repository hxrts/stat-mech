#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful"

echo "[check-faithful-clayb-cone] scanning $TARGET_DIR"

if rg -n --glob '*.lean' '^\s*(axiom|sorry)\b' "$TARGET_DIR"; then
  echo "[check-faithful-clayb-cone] FAIL: found axiom/sorry"
  exit 1
fi

if rg -n --glob '*.lean' -i '\b(witness|placeholder|unresolved|bridge)\b' "$TARGET_DIR"; then
  echo "[check-faithful-clayb-cone] FAIL: found banned placeholder-style tokens in faithful cone"
  exit 1
fi

echo "[check-faithful-clayb-cone] PASS"

