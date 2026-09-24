# History
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000

setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# Shell
setopt NOBEEP
setopt NUMERIC_GLOB_SORT

# Use Emacs keybind
bindkey -e

# Better prompt
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'
zstyle ':vcs_info:*' enable git
setopt PROMPT_SUBST
PROMPT='%F{blue}%~%f%F{yellow}${vcs_info_msg_0_}%f
%(?.%F{green}.%F{red})> %f'

# Completions
fpath=($XDG_DATA_HOME/zsh/site-functions $fpath)
zmodload zsh/complist
autoload -Uz compinit
ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump"
() {
  if (( $# )); then
    compinit -C -d "$ZSH_COMPDUMP"
  else
    mkdir -p "${ZSH_COMPDUMP:h}"
    compinit -d "$ZSH_COMPDUMP" && touch "$ZSH_COMPDUMP"
  fi
} $ZSH_COMPDUMP(N.mh-24)
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
bindkey "^N" menu-complete
bindkey -M menuselect "^N" down-line-or-history
bindkey -M menuselect "^P" up-line-or-history
bindkey -M menuselect "^M" .accept-line
bindkey -M menuselect "^[" accept-line

# Better ls
alias ls="ls -1F --color=always"
alias la="ls -1FA --color=always"
alias ll="ls -FAlh --color=always"

# mise
if (( $+commands[mise] )); then
  eval "$(mise activate zsh)"
fi

# neovim
if (( $+commands[nvim] )); then
  alias nv="nvim"
  export EDITOR=nvim
fi

# zoxide (cd replacement)
if (( $+commands[zoxide] )); then
  eval "$(zoxide init --cmd cd zsh)"
fi

# fzf
if (( $+commands[fzf] )); then
  eval "$(fzf --zsh)"
  export FZF_DEFAULT_COMMAND="fd --hidden --exclude .git"
  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview '[ -d {} ] && \
    (ls -1FA --color=always) || \
    (bat --color=always -n --line-range :100 {} 2>/dev/null || cat {})'"
fi

# bat (cat replacement)
if (( $+commands[bat] )); then
  alias cat="bat --color=always -n --line-range :500"
fi

# zsh-syntax-highlighting, zsh-autosuggestions
ZSH_PLUGINS_DIR="$XDG_DATA_HOME/zsh/plugins"
source "$ZSH_PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
bindkey "^Y" autosuggest-accept
