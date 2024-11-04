# constant
export gh=https://github.com
export myghname=quantumsnowball
export mygh=$gh/$myghname
export myghssh=git@github.com:$myghname
# git
alias gts='git status -uall'
alias gtl='git log --oneline'

#helpers
clone-my-repo() {
    local use_ssh=false
    if [ "$1" = "-rw" ] || [ "$1" = "-ssh" ]; then
        use_ssh=true
        shift
    fi
    if [ -z "$1" ]; then
        echo "Usage: clone-my-repo [-ssh] <repo> [<git-args>]"
        return 1
    fi
    local repo="$1"
    shift
    if $use_ssh; then
        # echo "git clone $myghssh/$repo.git $@"
        git clone "$myghssh/$repo.git" "$@"
    else
        # echo "git clone $mygh/$repo.git $@"
        git clone "$mygh/$repo.git" "$@"
    fi
}
