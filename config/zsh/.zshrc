# History
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000

setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

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
  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
fi
