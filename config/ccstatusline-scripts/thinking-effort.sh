#!/bin/sh
# ccstatusline custom-command: live effort level for the current session.
#
# Scans the session transcript (tail) for the most recent marker CC emits on
# every /effort or /model switch:
#   <local-command-stdout>Set effort level to X ...</local-command-stdout>
#   <local-command-stdout>Set model to ... with X effort</local-command-stdout>
# Falls back to ~/.claude/settings.json's effortLevel, then "default".
#
# Why not the built-in thinking-effort widget? It hardcodes a known list
# (low|medium|high|xhigh|max) and renders any other value with a trailing "?",
# so "ultracode" appears as "ultracode?". This script displays the raw level
# cleanly and supports any future effort name without an upstream update.

stdin=$(cat)
transcript=$(printf '%s' "$stdin" | jq -r '.transcript_path // empty' 2>/dev/null)

effort=
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
    effort=$(tail -n 1000 "$transcript" 2>/dev/null | awk '
        /<local-command-stdout>Set effort level to / {
            s = $0
            sub(/.*<local-command-stdout>Set effort level to /, "", s)
            sub(/[^a-zA-Z0-9-].*/, "", s)
            last = s
        }
        /<local-command-stdout>Set model to .* with [a-zA-Z0-9-]+ effort/ {
            s = $0
            match(s, / with [a-zA-Z0-9-]+ effort/)
            s = substr(s, RSTART + 6); sub(/ effort.*/, "", s)
            last = s
        }
        END { if (last) print last }
    ')
fi

if [ -z "$effort" ]; then
    effort=$(jq -r '.effortLevel // empty' "$HOME/.claude/settings.json" 2>/dev/null)
fi

[ -z "$effort" ] && effort=default
printf '%s' "$effort"
