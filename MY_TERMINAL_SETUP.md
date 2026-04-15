# My Ghostty Terminal Setup

## What each piece is

- `Ghostty`: the terminal emulator, meaning the app window itself
- `zsh`: the shell that reads and runs commands
- `nvim`: the terminal editor
- `starship`: the Powerline-style prompt
- `yazi`: the terminal file manager
- `codex`: the AI agent CLI for coding and terminal work

## Community terms

- `Powerline-style prompt`: the segmented prompt style with arrow separators
- `Prompt symbol`: the final character before the cursor
- `Ghostty splits`: splits managed directly by Ghostty
- `Alt screen`: when a terminal app takes over the visible terminal area and later returns

## Current configuration

- Ghostty stays my only terminal emulator
- Ghostty uses `Gruvbox Dark`
- Ghostty uses a `bar` cursor across tabs and splits
- Ghostty is based on the style of `bruceblue-ghostty-config`, but adapted for my machine and Codex
- Ghostty fonts in fallback order:
  `Fira Code` -> `LXGW WenKai Mono` -> `JetBrainsMono Nerd Font Mono`
- `starship` uses the Gruvbox Rainbow preset style
- `nvim` uses Gruvbox Dark and the same Vim leader and movement habits I use in VS Code
- The prompt is not a bottom status line; it is the shell prompt
- The prompt shows git context when I am inside a git repo
- `yazi` is opened with `y`
- `cx` runs `codex --no-alt-screen`
- `VISUAL` and `EDITOR` both point to `nvim`

## Why tmux was removed

- The new setup uses Ghostty-native splits instead
- That matches the reference Ghostty config better
- It removes one extra layer and keeps the toolset cleaner

The redundant tool removed from this setup is:

- `tmux`

## Ghostty settings I now use

- transparent Gruvbox background with blur
- larger padding for a calmer layout
- bar cursor
- quick terminal toggle
- very large scrollback
- safer paste behavior
- Option key works as Alt for terminal shortcuts

Useful Ghostty keys:

- `Cmd-D`: split right
- `Cmd-Shift-D`: split down
- `Cmd-Shift-Enter`: zoom or unzoom the current split
- `Cmd-Shift-F`: toggle the Ghostty quick terminal
- `Cmd-T`: new tab
- `Cmd-N`: new window

## How to customize the Powerline prompt

Main file:

- `~/.config/starship.toml`

What to change:

- `format`: controls segment order
- `[palettes.gruvbox_dark]`: controls colors
- `[os]`, `[username]`, `[hostname]`, `[directory]`, `[custom.env_block]`, `[git_branch]`, `[git_state]`, `[git_status]`, `[time]`: control segments
- `[character]`: controls the prompt symbol area

Repo source of truth:

- `config/starship.toml`

## How to customize Ghostty

Main file:

- `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`

Repo source of truth:

- `config/ghostty.config`

Good things to customize later:

- opacity
- blur
- padding
- quick terminal behavior
- split keybindings

## Codex workflow

Practical layout:

- use one Ghostty split for Codex
- use another Ghostty split for shell, editor, or Yazi

Useful options:

- `codex`: normal interactive mode
- `cx`: Codex inline in scrollback using `--no-alt-screen`
- `Ctrl-g` in the Codex composer: open the current draft in `nvim`

About final output vs process output:

- Codex CLI does not currently expose a clean separate theme setting for final output versus process or thinking output
- The practical solution is layout separation:
  one split, tab, or window for Codex, and another for everything else

About external editor behavior:

- right now `Ctrl-g` opens `nvim` in the same terminal surface that is running Codex
- this covers the current Ghostty split while editing
- the “send that temp file to a dedicated editor split” workaround is intentionally not enabled yet

## Main commands

```bash
y
cx
source ~/.zshrc
```

What they do:

- `y`: open Yazi
- `cx`: run Codex inline in scrollback
- `source ~/.zshrc`: reload shell config

## Yazi behavior

- Markdown preview is rendered, not raw
- opening `*.md`, `*.markdown`, `*.mdx`, `*.rmd`, and `*.qmd` uses rendered `glow` output first
- `*.R` opens in `nvim`
- preview and open support exists for `pdf`, `xlsx`, `pptx`, and `docx`
- preview support also exists for common archives such as `zip`, `7z`, `rar`, `tar`, `tar.gz`, `tar.bz2`, and `tar.xz`
- in Yazi, `J` and `K` seek the preview by 5 units
- `g h` jumps to home and `g d` jumps to `~/Downloads`

## Neovim behavior

- colorscheme: Gruvbox Dark
- `jj`: leave insert mode
- `H` and `L`: jump to first and last non-blank character
- `J` and `K`: move 5 lines down or up
- `<C-n>`: clear search highlight
- `<Space>c`: toggle booleans under the cursor
- `<Space>t`: focus or open a terminal split
- `<Tab>h` and `<Tab>l`: switch tabs
- Flash provides easy-motion-style jumps on `<Space><Space>s`, `<Space><Space>w`, `<Space><Space>b`, `<Space><Space>j`, and `<Space><Space>k`

## Package set actually used

- core tools: `ghostty`, `zsh`, `nvim`, `yazi`, `starship`, `codex`
- Yazi helper tools kept in the installer: `glow`, `poppler`, `sevenzip`, `fd`, `fzf`, `zoxide`, `jq`
- heavy optional media tools from the upstream Yazi docs are intentionally not installed by default

## Git prompt behavior

- inside a git repo, the prompt shows the current branch
- ongoing git operations such as rebase or merge are shown on the prompt line
- repo state is shown in a balanced form, especially ahead/behind and dirty markers
- outside git repos, no git segment is shown
