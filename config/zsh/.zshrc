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
fpath=($XDG_DATA_HOME/mise-completions/zsh $fpath)

# Use emacs keymaps to enable Ctrl-N and Ctrl-P to work with zsh-autocomplete
bindkey -e

# Better ls
alias ls="ls -1F --color=always"
alias la="ls -1FA --color=always"
alias ll="ls -FAlh --color=always"

# mise
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

# neovim
if command -v nvim &>/dev/null; then
  alias nv="nvim"
  export EDITOR=nvim
fi

# zoxide (cd replacement)
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init --cmd cd zsh)"
fi

# fzf
if command -v fzf &>/dev/null; then
  eval "$(fzf --zsh)"
  export FZF_DEFAULT_COMMAND="fd --hidden --exclude .git"
  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview '[ -d {} ] && (ls -1FA --color=always) || (bat --color=always -n --line-range :500 {} 2>/dev/null || cat {})'"
  export FZF_CTRL_R_OPTS="--preview ''"
fi

# bat (cat replacement)
if command -v bat &>/dev/null; then
  alias cat="bat --color=always -n --line-range :500"
fi

# zsh-syntax-highlighting, zsh-autocomplete, zsh-autosuggestions
ZSH_PLUGINS_DIR="$XDG_DATA_HOME/zsh/plugins"
source "$ZSH_PLUGINS_DIR/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
source "$ZSH_PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Navigation in menu selection
bindkey -M menuselect "^[[D" .backward-char "^[OD" .backward-char
bindkey -M menuselect "^[[C" .forward-char  "^[OC" .forward-char
bindkey -M menuselect "^B" .backward-char
bindkey -M menuselect "^F" .forward-char
bindkey -M menuselect "^M" .accept-line
bindkey "^Y" autosuggest-accept

