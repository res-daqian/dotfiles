#!/bin/sh
# ccstatusline custom-command widget: context window usage as plain text.
# Emits e.g. "Ctx: 185k/1000k (18%)". Reads the JSON Claude Code passes
# on stdin (same as the built-in context-bar widget) but skips the bar.
data=$(cat)
read window used <<EOF
$(printf '%s' "$data" | jq -r '
  .context_window as $cw
  | if $cw == null or ($cw.context_window_size // 0) == 0 then
      empty
    else
      ($cw.context_window_size) as $w
      | (
          if $cw.used_percentage != null then
            ($cw.used_percentage / 100 * $w)
          elif ($cw.current_usage | type) == "number" then
            $cw.current_usage
          elif $cw.current_usage != null then
            (($cw.current_usage.input_tokens // 0)
             + ($cw.current_usage.output_tokens // 0)
             + ($cw.current_usage.cache_creation_input_tokens // 0)
             + ($cw.current_usage.cache_read_input_tokens // 0))
          else 0 end
        ) as $u
      | "\($w) \($u)"
    end' 2>/dev/null)
EOF
[ -z "$window" ] && exit 0

window_k=$(awk -v w="$window" 'BEGIN { printf "%d", w/1000 }')
used_k=$(awk -v u="$used" 'BEGIN { printf "%d", u/1000 }')
pct=$(awk -v u="$used" -v w="$window" 'BEGIN { printf "%d", u/w*100 }')

printf 'Ctx: %sk/%sk (%s%%)' "$used_k" "$window_k" "$pct"
