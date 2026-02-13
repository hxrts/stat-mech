#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveSpineGlobal.lean"

echo "[check-decisive-spine-global-derived] checking global layer"

for pattern in \
  "decisiveSpine_global_critical_control" \
  "decisiveSpine_global_extension" \
  "decisiveSpine_global_smoothness_persistence" \
  "decisiveSpine_no_direct_injection_policy"
do
  if ! rg -n "$pattern" "$FILE" >/dev/null; then
    echo "[check-decisive-spine-global-derived] FAIL: missing $pattern" >&2
    exit 1
  fi
done

if rg -n "^theorem decisiveSpine_global_critical_control_direct\\b|^theorem decisiveSpine_global_critical_control_from_data\\b|^theorem decisiveSpine_global_extension_direct\\b|^theorem decisiveSpine_global_extension_from_data\\b|^theorem decisiveSpine_global_smoothness_persistence_direct\\b|^theorem decisiveSpine_global_smoothness_persistence_from_data\\b" "$FILE" >/dev/null; then
  echo "[check-decisive-spine-global-derived] FAIL: retired decisive-spine global direct/from-data wrappers reintroduced" >&2
  rg -n "^theorem decisiveSpine_global_critical_control_direct\\b|^theorem decisiveSpine_global_critical_control_from_data\\b|^theorem decisiveSpine_global_extension_direct\\b|^theorem decisiveSpine_global_extension_from_data\\b|^theorem decisiveSpine_global_smoothness_persistence_direct\\b|^theorem decisiveSpine_global_smoothness_persistence_from_data\\b" "$FILE" >&2
  exit 1
fi

CRIT_BLOCK="$(
  awk '
    /theorem decisiveSpine_global_critical_control$/ {flag=1}
    flag {print}
    flag && /^\/-! ## Global extension theorems -\// {exit}
  ' "$FILE"
)"

if [[ -z "$CRIT_BLOCK" ]]; then
  echo "[check-decisive-spine-global-derived] FAIL: missing decisiveSpine_global_critical_control block" >&2
  exit 1
fi

if ! echo "$CRIT_BLOCK" | rg -n "decisiveSpine_global_closure_from_incompatibility_data" >/dev/null; then
  echo "[check-decisive-spine-global-derived] FAIL: global critical control theorem is not routed through decisiveSpine_global_closure_from_incompatibility_data" >&2
  echo "$CRIT_BLOCK" >&2
  exit 1
fi

EXT_BLOCK="$(
  awk '
    /theorem decisiveSpine_global_extension$/ {flag=1}
    flag {print}
    flag && /^\/-- Long-time continuation\/global extension from decisive-spine incompatibility data\./ {exit}
  ' "$FILE"
)"

if [[ -z "$EXT_BLOCK" ]]; then
  echo "[check-decisive-spine-global-derived] FAIL: missing decisiveSpine_global_extension block" >&2
  exit 1
fi

if ! echo "$EXT_BLOCK" | rg -n "fullProof_longTime_continuation_globalExtension" >/dev/null; then
  echo "[check-decisive-spine-global-derived] FAIL: global extension theorem is not routed through fullProof_longTime_continuation_globalExtension" >&2
  echo "$EXT_BLOCK" >&2
  exit 1
fi

SMOOTH_BLOCK="$(
  awk '
    /theorem decisiveSpine_global_smoothness_persistence$/ {flag=1}
    flag {print}
    flag && /^\/-! ## Policy markers -\// {exit}
  ' "$FILE"
)"

if [[ -z "$SMOOTH_BLOCK" ]]; then
  echo "[check-decisive-spine-global-derived] FAIL: missing decisiveSpine_global_smoothness_persistence block" >&2
  exit 1
fi

if ! echo "$SMOOTH_BLOCK" | rg -n "fullProof_smoothness_persistence" >/dev/null; then
  echo "[check-decisive-spine-global-derived] FAIL: global smoothness theorem is not routed through fullProof_smoothness_persistence" >&2
  echo "$SMOOTH_BLOCK" >&2
  exit 1
fi

if rg -n 'vel\s*:=\s*fun _ =>|press\s*:=\s*fun _ =>|dvel\s*:=\s*fun _ =>' "$FILE" >/dev/null; then
  echo "[check-decisive-spine-global-derived] FAIL: found direct formula injection in decisive global file" >&2
  exit 1
fi

if rg -n "BaseAxiomPrimitiveExtensionWitness|extension_hypotheses" "$FILE" >/dev/null; then
  echo "[check-decisive-spine-global-derived] FAIL: found legacy extension-witness plumbing in decisive-spine global file" >&2
  exit 1
fi

echo "[check-decisive-spine-global-derived] PASS"
