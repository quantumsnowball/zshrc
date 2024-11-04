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
    # default use https url
    local use_ssh=false

    # if -rw or -ssh flag active, use ssh url
    # only machine with authorized private key installed can write to repo
    if [ "$1" = "-ssh" ] || [ "$1" = "-rw" ]; then
        use_ssh=true
        shift
    fi

    # the arg that follows is always the repo name
    if [ -z "$1" ]; then
        echo "Usage: clone-my-repo [-ssh|-rw] <repo> [<git clone args>]"
        return 1
    fi
    local repo="$1"

    # after the repo name, all following args ($@) are passed onto git clone
    shift
    if $use_ssh; then
        # echo "git clone $myghssh/$repo.git $@"
        git clone "$myghssh/$repo.git" "$@"
    else
        # echo "git clone $mygh/$repo.git $@"
        git clone "$mygh/$repo.git" "$@"
    fi
}
