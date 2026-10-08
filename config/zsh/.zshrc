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
setopt PROMPT_SUBST
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' (%b)'
precmd() { vcs_info }
PROMPT='%F{blue}%~%F{yellow}${vcs_info_msg_0_}%f
%F{green}> %f'

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
zstyle ':completion:*' menu yes select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' select-prompt '%S%p%s'
LISTMAX=100000
bindkey -M menuselect "^N" down-line-or-history
bindkey -M menuselect "^P" up-line-or-history
bindkey -M menuselect "^M" .accept-line
bindkey -M menuselect "^[" accept-line

# Better ls
alias ls="ls -1F --color=always"
alias la="ls -1FA --color=always"
alias ll="ls -FAlh --color=always"

# mise
(( $+commands[mise] )) && eval "$(mise activate zsh)"

# neovim
export EDITOR="${commands[nvim]:-vim}"

# fzf
if (( $+commands[fzf] )); then
  eval "$(fzf --zsh)"
  (( $+commands[fd] )) && export FZF_DEFAULT_COMMAND="fd --hidden --exclude .git"
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview "
    if [ -d {} ]; then
      ls -1FA --color=always {}
    else
      bat --color=always -n --line-range :100 {} 2>/dev/null || cat {}
    fi"'
fi

# bat (cat replacement)
(( $+commands[bat] )) && alias cat="bat --color=always -n --line-range :500"
