#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful"

echo "[check-base-axiom-cone-no-axiom-sorry] scanning base-axiom files"

if rg -n --glob 'BaseAxiom*.lean' '^\s*(axiom|sorry)\b' "$TARGET_DIR"; then
  echo "[check-base-axiom-cone-no-axiom-sorry] FAIL: found axiom/sorry in base-axiom files" >&2
  exit 1
fi

echo "[check-base-axiom-cone-no-axiom-sorry] PASS"
