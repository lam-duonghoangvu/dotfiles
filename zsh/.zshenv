# zsh global environment
if [[ -z "$XDG_CONFIG_HOME" ]]; then
  export XDG_CONFIG_HOME="$HOME/.config"
fi
if [[ -d "$XDG_CONFIG_HOME/zsh" ]]; then
  export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
fi

# XDG base directories
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Personal binaries scripts
typeset -U PATH
export PATH="$HOME/.local/bin:$PATH"

# Sessions directory
export SHELL_SESSION_DIR="$XDG_STATE_HOME/zsh/sessions"

# Pager
export MANPAGER="bat -l man -p"

# Brew
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
[[ -x /home/linuxbrew/.linuxbrew/bin/brew ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
export HOMEBREW_BREWFILE="$XDG_CONFIG_HOME/brew/Brewfile"
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1