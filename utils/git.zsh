# constant
export gh=https://github.com
export mygh=$gh/quantumsnowball
# git
alias gts='git status -uall'
alias gtl='git log --oneline'

#helpers
clone-my-repo() {
    if [ -z "$1" ]; then
        echo "Usage: clone-my-repo <repo>"
        return 1
    fi
    # git clone
    git clone "$mygh/$1.git"
}
