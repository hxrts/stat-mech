#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
THEOREM_FILE="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/BaseAxiomCompletion.lean"
OUT="$ROOT/work/navier_clayb_checkpoint.txt"

if [[ ! -f "$THEOREM_FILE" ]]; then
  echo "[freeze-clayb-checkpoint] missing theorem file: $THEOREM_FILE" >&2
  exit 1
fi

THEOREM_SHA="$(shasum -a 256 "$THEOREM_FILE" | awk '{print $1}')"
HEAD_SHA="$(git -C "$ROOT" rev-parse HEAD 2>/dev/null || echo 'UNKNOWN')"
DIRTY_COUNT="$(git -C "$ROOT" status --porcelain | wc -l | tr -d ' ')"
NOW_UTC="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

cat > "$OUT" <<EOF
# Clay(B) Checkpoint

Generated: $NOW_UTC
Git HEAD: $HEAD_SHA
Dirty entries at freeze time: $DIRTY_COUNT

Theorem file:
StatMech/ContinuumField/NavierStokes/Faithful/BaseAxiomCompletion.lean

SHA-256:
$THEOREM_SHA
EOF

echo "[freeze-clayb-checkpoint] wrote $OUT"
