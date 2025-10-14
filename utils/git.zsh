# constant
export gh=https://github.com
export myghname=quantumsnowball
export mygh=$gh/$myghname
export myghssh=git@github.com:$myghname


ensure git || return

# pager
export GIT_PAGER="less"

# git
alias gts='git status -uall'
alias gtl='git log --oneline'

#helpers
gh.clone-my-repo() {
    # default use https url
    local use_ssh=false
    local use_token=false
    local help="Usage: gh.clone-my-repo [-ssh|-rw|-token] <repo> [<git clone args>]"

    # if -rw or -ssh flag active, use ssh url
    # only machine with authorized private key installed can write to repo
    if [ "$1" = "-ssh" ] || [ "$1" = "-rw" ]; then
        use_ssh=true
        shift
    # if -token flag active, use https with username prefixed domain
    elif [ "$1" = "-token" ]; then
        # NOTE: 
        # to clone private repo, create the token with Depository access: All repositories
        # also at least grant Repository permissions > Contents > Access: Read-only
        use_token=true
        shift
    elif [[ "$1" == -* ]]; then
        echo "Error: invalid flag"
        echo $help
        return 1 
    fi

    # the arg that follows is always the repo name
    if [ -z "$1" ]; then
        echo "Error: please provide repo name to clone"
        echo $help
        return 1
    fi
    local repo="$1"
    shift

    # after the repo name, all following args ($@) are passed onto git clone
    if $use_ssh; then
        # echo "git clone $myghssh/$repo.git $@"
        git clone "$myghssh/$repo.git" "$@"
    elif $use_token; then
        echo -n "GitHub personal access token: "
        read -s token
        git clone "https://$myghname:$token@github.com/$myghname/$repo.git" "$@"
    else
        # echo "git clone $mygh/$repo.git $@"
        git clone "$mygh/$repo.git" "$@"
    fi
}


ensure gh || return


gh.search-my-repo() {
    # use gh cli helper, need a read-only api token
    gh search repos \
        --owner=quantumsnowball \
        --sort=updated \
        --order=desc \
        --limit=20 \
        --json name,language,visibility,updatedAt \
        --template '{{range .}}{{
            tablerow 
            (.name | autocolor "white") 
            (printf "%.7s" .language | autocolor "yellow") 
            (.visibility | autocolor "cyan") 
            (printf "%.9s" (timeago .updatedAt) | autocolor "green")
        }}{{end}}' \
        "$@"
}
