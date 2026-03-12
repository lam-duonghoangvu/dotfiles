
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/duonghoangvulam/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
eval "$(zoxide init --cmd cd zsh)"
eval "$(starship init zsh)"
alias ls="eza --color=always --icons=always --long --git --no-filesize --no-time --no-user --no-permissions"
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
