# pyenv
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

# zoxide
eval "$(zoxide init zsh)"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--border --layout=reverse --height=50% --min-height=20'
