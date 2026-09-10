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

# misecompsync
fpath=(~/.local/share/mise-completions/zsh $fpath)

# neovim
if command -v nvim &>/dev/null; then
  alias nv="nvim"
  export EDITOR=nvim
fi

# starship
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
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
source "$HOME/.zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
source "$HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Navigation in menu selection
bindkey -M menuselect "^[[D" .backward-char "^[OD" .backward-char
bindkey -M menuselect "^[[C" .forward-char  "^[OC" .forward-char
bindkey -M menuselect "^B" .backward-char
bindkey -M menuselect "^F" .forward-char
bindkey -M menuselect "^M" .accept-line
bindkey "^Y" autosuggest-accept

