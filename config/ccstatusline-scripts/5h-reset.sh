#!/bin/sh
# ccstatusline custom-command widget: 5h block reset countdown.
# Used instead of the built-in block-reset-timer because that widget
# returns null between blocks and a ccstatusline rendering quirk then
# silently swallows every widget after it on the same line. Reading
# the cache directly avoids that path entirely.
fallback='5h Reset: --'
cache="$HOME/.cache/ccstatusline/usage.json"

if [ ! -f "$cache" ]; then
  printf '%s' "$fallback"; exit 0
fi

reset_at=$(jq -r '.sessionResetAt // empty' "$cache" 2>/dev/null)
if [ -z "$reset_at" ]; then
  printf '%s' "$fallback"; exit 0
fi

# Strip fractional seconds and timezone suffix for BSD `date` compatibility.
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

h=$((remaining / 3600))
m=$((remaining % 3600 / 60))

if [ "$h" -gt 0 ]; then
  printf '5h Reset: %dh %dm' "$h" "$m"
else
  printf '5h Reset: %dm' "$m"
fi
