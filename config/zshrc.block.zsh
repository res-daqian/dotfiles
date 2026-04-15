# Load Homebrew into the shell environment when available.
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Starship gives you the Powerline-style prompt shown in Ghostty.
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Run Codex inline in scrollback instead of taking over the alternate screen.
alias cx='codex --no-alt-screen'

# Use Neovim as the default editor for shells and TUIs that honor EDITOR/VISUAL.
export VISUAL="nvim"
export EDITOR="nvim"

# Fish-style inline suggestions from shell history and completions.
if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Launch Yazi and move the shell into the last directory you visited there.
function y() {
  local tmp cwd

  tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="$tmp"
  cwd="$(cat -- "$tmp" 2>/dev/null)" || true

  if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi

  rm -f -- "$tmp"
}
