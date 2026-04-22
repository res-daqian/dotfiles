#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/config"

ZSHRC="$HOME/.zshrc"
ZPROFILE="$HOME/.zprofile"
CONDARC="$HOME/.condarc"
STARSHIP_CONF="$HOME/.config/starship.toml"
YAZI_DIR="$HOME/.config/yazi"
YAZI_CONF="$YAZI_DIR/yazi.toml"
YAZI_KEYMAP="$YAZI_DIR/keymap.toml"
YAZI_PACKAGE="$YAZI_DIR/package.toml"
YAZI_SCRIPTS_DIR="$YAZI_DIR/scripts"
NVIM_DIR="$HOME/.config/nvim"
GHOSTTY_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty"
GHOSTTY_CONF="$GHOSTTY_DIR/config.ghostty"

TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

require_command() {
  local name="$1"
  if ! command -v "$name" >/dev/null 2>&1; then
    echo "Missing required command: $name" >&2
    exit 1
  fi
}

backup_file() {
  local path="$1"
  if [ -f "$path" ]; then
    cp "$path" "$path.bak.$TIMESTAMP"
  fi
}

backup_path() {
  local path="$1"
  if [ -e "$path" ]; then
    cp -R "$path" "$path.bak.$TIMESTAMP"
  fi
}

ensure_parent_dir() {
  local path="$1"
  mkdir -p "$(dirname "$path")"
}

install_packages() {
  local packages=("$@")
  local missing=()
  local pkg

  for pkg in "${packages[@]}"; do
    if ! brew list --formula "$pkg" >/dev/null 2>&1; then
      missing+=("$pkg")
    fi
  done

  if [ "${#missing[@]}" -gt 0 ]; then
    echo "Installing: ${missing[*]}"
    brew install "${missing[@]}"
  else
    echo "Homebrew packages already installed."
  fi
}

cleanup_obsolete_tmux() {
  local old_tmux_conf="$HOME/.tmux.conf"
  local old_tmux_dir="$HOME/.config/tmux"
  local old_tmux_status="$old_tmux_dir/status-right.sh"

  if [ -f "$old_tmux_conf" ]; then
    backup_file "$old_tmux_conf"
    rm -f "$old_tmux_conf"
  fi

  if [ -f "$old_tmux_status" ]; then
    backup_file "$old_tmux_status"
    rm -f "$old_tmux_status"
  fi

  if [ -d "$old_tmux_dir" ] && [ -z "$(find "$old_tmux_dir" -mindepth 1 -print -quit 2>/dev/null)" ]; then
    rmdir "$old_tmux_dir"
  fi
}

main() {
  require_command brew
  require_command git

  # Lean Yazi helper set: search, archives, PDFs, and quick navigation.
  install_packages neovim yazi starship glow poppler sevenzip fd fzf zoxide jq zsh-autosuggestions
  if ! command -v python3 >/dev/null 2>&1; then
    brew install python
  fi
  require_command ya
  require_command nvim

  mkdir -p "$HOME/.config" "$YAZI_DIR" "$YAZI_SCRIPTS_DIR"
  mkdir -p "$GHOSTTY_DIR"

  backup_file "$ZSHRC"
  backup_file "$ZPROFILE"
  backup_file "$CONDARC"
  backup_file "$STARSHIP_CONF"
  backup_file "$YAZI_CONF"
  backup_file "$YAZI_KEYMAP"
  backup_file "$YAZI_PACKAGE"
  backup_file "$GHOSTTY_CONF"
  backup_file "$YAZI_SCRIPTS_DIR/preview_pdf.sh"
  backup_file "$YAZI_SCRIPTS_DIR/preview_xlsx.py"
  backup_file "$YAZI_SCRIPTS_DIR/preview_pptx.py"
  backup_file "$YAZI_SCRIPTS_DIR/preview_docx.sh"
  backup_file "$YAZI_SCRIPTS_DIR/preview_archive.sh"
  backup_path "$NVIM_DIR"

  cleanup_obsolete_tmux

  install -m 0644 "$CONFIG_DIR/zshrc" "$ZSHRC"
  install -m 0644 "$CONFIG_DIR/zprofile" "$ZPROFILE"
  install -m 0644 "$CONFIG_DIR/condarc" "$CONDARC"
  install -m 0644 "$CONFIG_DIR/starship.toml" "$STARSHIP_CONF"
  install -m 0644 "$CONFIG_DIR/yazi.toml" "$YAZI_CONF"
  install -m 0644 "$CONFIG_DIR/yazi.keymap.toml" "$YAZI_KEYMAP"
  install -m 0644 "$CONFIG_DIR/yazi.package.toml" "$YAZI_PACKAGE"
  install -m 0755 "$CONFIG_DIR/yazi-scripts/preview_pdf.sh" "$YAZI_SCRIPTS_DIR/preview_pdf.sh"
  install -m 0755 "$CONFIG_DIR/yazi-scripts/preview_xlsx.py" "$YAZI_SCRIPTS_DIR/preview_xlsx.py"
  install -m 0755 "$CONFIG_DIR/yazi-scripts/preview_pptx.py" "$YAZI_SCRIPTS_DIR/preview_pptx.py"
  install -m 0755 "$CONFIG_DIR/yazi-scripts/preview_docx.sh" "$YAZI_SCRIPTS_DIR/preview_docx.sh"
  install -m 0755 "$CONFIG_DIR/yazi-scripts/preview_archive.sh" "$YAZI_SCRIPTS_DIR/preview_archive.sh"
  YAZI_CONFIG_HOME="$YAZI_DIR" ya pkg install
  mkdir -p "$NVIM_DIR"
  cp -R "$CONFIG_DIR/nvim/." "$NVIM_DIR/"
  nvim --headless "+Lazy! sync" +qa
  install -m 0644 "$CONFIG_DIR/ghostty.config" "$GHOSTTY_CONF"

  echo
  echo "Installation complete."
  echo "Open a new Ghostty window or run: source ~/.zshrc"
  echo "Then use:"
  echo "  y   -> open Yazi"
  echo "  cx  -> run Codex inline in scrollback"
}

main "$@"
