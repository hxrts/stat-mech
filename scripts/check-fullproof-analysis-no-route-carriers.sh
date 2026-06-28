#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful"
ANALYSIS_FILE="$TARGET/FullProofExactAnalysis.lean"
LOCAL_FILE="$TARGET/FullProofExactLocalTheory.lean"

echo "[check-fullproof-analysis-no-route-carriers] checking full-proof analysis/local-theory carriers"

if rg -n "FullProofExactAnalysisRoute" "$ANALYSIS_FILE" "$LOCAL_FILE" >/dev/null; then
  echo "[check-fullproof-analysis-no-route-carriers] FAIL: FullProofExactAnalysisRoute still present" >&2
  rg -n "FullProofExactAnalysisRoute" "$ANALYSIS_FILE" "$LOCAL_FILE" >&2
  exit 1
fi

if rg -n "\\.route\\." "$LOCAL_FILE" >/dev/null; then
  echo "[check-fullproof-analysis-no-route-carriers] FAIL: local-theory still uses route field access" >&2
  rg -n "\\.route\\." "$LOCAL_FILE" >&2
  exit 1
fi

echo "[check-fullproof-analysis-no-route-carriers] PASS"
