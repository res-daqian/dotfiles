#!/bin/sh
# ccstatusline custom-command widget: real thinking effort readout.
#
# The built-in thinking-effort widget hardcodes a legacy allowlist
# (low|medium|high|max) and silently falls back to "medium" when
# settings.json contains a newer value such as "xhigh". This script
# reads the current effortLevel directly from ~/.claude/settings.json
# so the statusline reflects reality.
effort=$(jq -r '.effortLevel // empty' "$HOME/.claude/settings.json" 2>/dev/null)
[ -z "$effort" ] && effort=default
printf 'Thinking: %s' "$effort"
