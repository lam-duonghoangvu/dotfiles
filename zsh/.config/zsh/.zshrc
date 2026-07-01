# History
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# Shell
setopt AUTO_CD
setopt NOBEEP
setopt NUMERIC_GLOB_SORT

# NOTE: starship
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# NOTE: zoxide (cd replacement)
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init --cmd cd zsh)"
fi

# NOTE: eza (ls replacement)
if command -v eza &>/dev/null; then
  alias ls="eza --color --icons --long --git --no-permissions --no-filesize --no-user --no-time"
  alias ll="eza --color --icons --long --header --git"
  alias la="eza --color --icons --long --all --header --git"
  alias tree="eza --tree --color --icons"
fi

# NOTE: bat (cat replacement)
if command -v bat &>/dev/null; then
  alias cat="bat --color=always -n --line-range :500"
fi

# NOTE: zsh-syntax-highlighting, zsh-autocomplete, zsh-autosuggestions
if command -v brew &>/dev/null; then
  _brew=$(brew --prefix)
  source "$_brew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  source "$_brew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
  source "$_brew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  unset _brew

  bindkey -M menuselect '^[[D' .backward-char '^[OD' .backward-char
  bindkey -M menuselect '^[[C' .forward-char  '^[OC' .forward-char
  bindkey -M menuselect '\r' .accept-line
  bindkey '^I' autosuggest-accept
fi
