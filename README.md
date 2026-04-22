# Ghostty Terminal Setup

This bundle installs and configures a terminal-first macOS stack built around Ghostty-native tabs and splits:

- `Ghostty`: terminal emulator
- `Neovim`: terminal editor
- `yazi`: terminal file manager
- `starship`: Powerline-style shell prompt
- `codex`: AI coding assistant CLI

Terminology:

- Terminal emulator: the app window, here `Ghostty`
- Prompt: the line where you type commands
- Prompt symbol: the final character before your cursor
- Powerline: a segmented prompt style, not a separate app
- Split pane: one terminal surface split into two work areas
- Alt screen: when a terminal app temporarily takes over the visible terminal area

After installation:

- Run `y` to open Yazi
- Run `cx` to start Codex inline in scrollback
- `Ctrl-g` in the Codex composer opens the draft in `nvim`
- Use Ghostty splits and tabs instead of `tmux`

Current highlights:

- Ghostty uses `Gruvbox Dark` with a `bar` cursor
- `EDITOR` and `VISUAL` are set to `nvim`
- Starship shows balanced git context when you are inside a git repo
- Yazi renders Markdown and previews `pdf`, `xlsx`, `pptx`, `docx`, and common archives
- Neovim uses your VS Code-inspired keybindings and Gruvbox theme

Files in this repo:

- `config/ghostty.config`
- `config/nvim/`
- `install_terminal_stack.sh` — installs the stack and deploys all dotfiles below (with `.bak.<timestamp>` backups of any existing files)
- `config/zshrc` — full `~/.zshrc` (proxy, LM Studio, conda init, AI_TERMINAL_CONFIGS section)
- `config/zprofile` — full `~/.zprofile` (Homebrew shellenv, pipx PATH)
- `config/condarc` — full `~/.condarc` (`auto_activate: false` so conda is on-demand)
- `config/yazi.toml`
- `config/yazi.keymap.toml`
- `config/starship.toml`
