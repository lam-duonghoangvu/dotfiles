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

# zsh-autocomplete runs its own compinit into $XDG_CACHE_HOME/zsh/compdump.
export skip_global_compinit=1

# Binary paths
typeset -U PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/scripts:$PATH"

# Sessions directory
export SHELL_SESSION_DIR="$XDG_STATE_HOME/zsh/sessions"

# Pager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Brew
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
