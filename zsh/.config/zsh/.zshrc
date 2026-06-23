# NOTE: starship
eval "$(starship init zsh)"

# NOTE: zoxide (cd replacement)
eval "$(zoxide init --cmd cd zsh)"

# NOTE: eza (ls replacement)
alias ls="eza --color=always --icons=always --long --git --no-filesize --no-time --no-user --no-permissions"

# NOTE: bat (cat replacement)
alias cat="bat --color=always -n --line-range :500"
# Use bat in man
export MANPAGER="bat -plman"

# NOTE: zsh-syntax-highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# NOTE: zsh-autocomplete
source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
zstyle -e ':autocomplete:*:*' list-lines 'reply=5'

# NOTE: zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# Make Tab accept inline suggestions from zsh-autosuggestions if present,
# otherwise fall back to normal autocomplete completion
_original_tab_widget=$(bindkey '^I' | awk '{print $2}')
if [[ -z "$_original_tab_widget" ]]; then
  _original_tab_widget="expand-or-complete"
fi

_complete_or_accept() {
  if [[ -n "$POSTDISPLAY" ]]; then
    zle autosuggest-accept
  else
    zle $_original_tab_widget
  fi
}
zle -N _complete_or_accept
bindkey '^I' _complete_or_accept
