#!/bin/sh
# ccstatusline custom-command widget: weekly reset countdown.
# Custom rather than built-in so the format is "Xd Yh Zm" with spaces
# and short "h" label (built-in widget couples those: compact -> no
# spaces, non-compact -> "hr" label).
fallback='Weekly Reset: --'
cache="$HOME/.cache/ccstatusline/usage.json"

if [ ! -f "$cache" ]; then
  printf '%s' "$fallback"; exit 0
fi

reset_at=$(jq -r '.weeklyResetAt // empty' "$cache" 2>/dev/null)
if [ -z "$reset_at" ]; then
  printf '%s' "$fallback"; exit 0
fi

trimmed=${reset_at%%.*}
trimmed=${trimmed%%+*}
trimmed=${trimmed%Z}

reset_ts=$(date -j -u -f "%Y-%m-%dT%H:%M:%S" "$trimmed" "+%s" 2>/dev/null)
if [ -z "$reset_ts" ]; then
  printf '%s' "$fallback"; exit 0
fi

now=$(date "+%s")
remaining=$((reset_ts - now))

if [ "$remaining" -le 0 ]; then
  printf '%s' "$fallback"; exit 0
fi

d=$((remaining / 86400))
h=$((remaining % 86400 / 3600))
m=$((remaining % 3600 / 60))

parts=''
[ "$d" -gt 0 ] && parts="${d}d"
if [ "$h" -gt 0 ]; then
  [ -n "$parts" ] && parts="$parts "
  parts="${parts}${h}h"
fi
if [ "$m" -gt 0 ]; then
  [ -n "$parts" ] && parts="$parts "
  parts="${parts}${m}m"
fi
[ -z "$parts" ] && parts='0m'

printf 'Weekly Reset: %s' "$parts"
