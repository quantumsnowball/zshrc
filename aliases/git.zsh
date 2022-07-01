# git
alias gts='git status -uall'
alias gtl='git log --oneline'

# dotfiles git
alias dot='git --git-dir=$HOME/.dot --work-tree=$HOME'
alias dotgit='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dgts='dotgit status -uall'
alias dgtl='dotgit log --oneline'
alias dotlazygit='lazygit --git-dir .dotfiles --work-tree ~'

