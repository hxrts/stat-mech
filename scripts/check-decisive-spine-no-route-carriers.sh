#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful"

echo "[check-decisive-spine-no-route-carriers] checking decisive-spine route/package carriers"

if rg -n --glob 'DecisiveSpine*.lean' 'structure\s+DecisiveSpine.*(Route|Package)\b' "$TARGET" >/dev/null; then
  echo "[check-decisive-spine-no-route-carriers] FAIL: found decisive-spine route/package structure carrier(s)" >&2
  rg -n --glob 'DecisiveSpine*.lean' 'structure\s+DecisiveSpine.*(Route|Package)\b' "$TARGET" >&2
  exit 1
fi

if rg -n --glob 'DecisiveSpine*.lean' '\((R|P)\s*:\s*DecisiveSpine.*(Route|Package)\b' "$TARGET" >/dev/null; then
  echo "[check-decisive-spine-no-route-carriers] FAIL: found theorem endpoints taking decisive-spine route/package carriers" >&2
  rg -n --glob 'DecisiveSpine*.lean' '\((R|P)\s*:\s*DecisiveSpine.*(Route|Package)\b' "$TARGET" >&2
  exit 1
fi

echo "[check-decisive-spine-no-route-carriers] PASS"
