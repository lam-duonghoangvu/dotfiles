# ==========================================
# XDG Base Directories & Environment
# ==========================================
if [[ -z "$XDG_CONFIG_HOME" ]]; then
  export XDG_CONFIG_HOME="$HOME/.config"
fi
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Personal binaries & scripts (avoid duplicates in PATH)
if [[ ":$PATH:" != *":$HOME/.local/scripts:"* ]]; then
  export PATH="$HOME/.local/scripts:$PATH"
fi

# Pager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Homebrew environment
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1

# Cargo environment
if [[ -f "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi

# ==========================================
# Interactive Configurations
# ==========================================
if [[ $- == *i* ]]; then
  mkdir -p "$XDG_STATE_HOME/bash"
  HISTFILE="$XDG_STATE_HOME/bash/history"
  HISTSIZE=100000
  HISTFILESIZE=100000

  shopt -s histappend
  HISTCONTROL=ignoreboth:erasedups

  share_history() {
    history -a
    history -c
    history -r
  }
  if [[ -z "$PROMPT_COMMAND" ]]; then
    PROMPT_COMMAND="share_history"
  else
    if [[ "$PROMPT_COMMAND" != *"share_history"* ]]; then
      PROMPT_COMMAND="share_history; $PROMPT_COMMAND"
    fi
  fi

  bind "set bell-style none"
  set -o emacs

  bind '"\C-h": backward-char'
  bind '"\C-l": forward-char'

  # Readline enhancements for Zsh-like feel
  bind "set completion-ignore-case on"
  bind "set show-all-if-ambiguous on"

  # ------------------------------------------
  # Command Aliases & Integrations
  # ------------------------------------------
  # Neovim
  if command -v nvim &>/dev/null; then
    alias nv="nvim"
    export EDITOR=nvim
  fi

  # Starship prompt
  if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
  fi

  # Fastfetch
  if command -v fastfetch &>/dev/null; then
    alias ff="fastfetch"
  fi

  # Zoxide
  if command -v zoxide &>/dev/null; then
    eval "$(zoxide init --cmd cd bash)"
  fi

  # Fzf
  if command -v fzf &>/dev/null; then
    eval "$(fzf --bash)"
    export FZF_DEFAULT_COMMAND="fd --hidden --exclude .git"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd --type d --hidden --exclude .git"

    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview '[ -d {} ] && (eza --tree --color=always {} | head -200) || (bat --color=always --style=numbers --line-range :500 {} 2>/dev/null || cat {})'"
    export FZF_CTRL_R_OPTS="--preview ''"
  fi

  # Eza (ls replacement)
  if command -v eza &>/dev/null; then
    alias ls="eza --color --icons --long --git --no-permissions --no-filesize --no-user --no-time"
    alias la="eza --color --icons --long --git --no-permissions --no-filesize --no-user --no-time --all"
    alias ll="eza --color --icons --long --header --git --all"
    alias tree="eza --tree --color --icons"
  fi

  # Bat (cat replacement)
  if command -v bat &>/dev/null; then
    alias cat="bat --color=always -n --line-range :500"
  fi

  # ------------------------------------------
  # Completions
  # ------------------------------------------
  # Load system/homebrew bash completion if available
  if command -v brew &>/dev/null; then
    _brew=$(brew --prefix)
    if [[ -r "$_brew/etc/profile.d/bash_completion.sh" ]]; then
      source "$_brew/etc/profile.d/bash_completion.sh"
    fi
    unset _brew
  fi
fi
