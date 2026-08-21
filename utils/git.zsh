# constant
export gh=https://github.com
export myghname=quantumsnowball
export mygh=$gh/$myghname
export myghssh=git@github.com:$myghname


ensure git || return

# pager
export GIT_PAGER="less"

# git
alias git.log='git log --oneline --all'
git.log.grep() {
    git log --oneline --all -i --grep="$1"
}
git.log.diff.fzf() {
    git log -S "$1" --oneline --all -i |
        fzf --height=-1 \
            --preview-window=right,60% \
            --preview 'git show --color=always {1} | bat --color=always --style=auto' \
            --bind 'enter:execute(git show {1} | bat --color=always)'
}
git.blame.fzf() {
    file=$(git ls-files | fzf)
    [ -n "$file" ] && \
        git blame "$file" |
            fzf --height=-1 \
                --preview-window=bottom,60% \
                --preview 'git show {1} | bat --color=always --style=auto' \
                --bind 'enter:execute(git show {1} | bat --color=always)' \
}

# config
git.config-summary() {
    echo "${CYAN}--- Git config summary ---${RESET}"
    git config --list --show-scope
}
git.global.set-default-user() {
    git config --global user.name "Quantum Snowball"
    git config --global user.email "quantum.snowball@gmail.com"
    git.config-summary
}
git.global.set-user() {
    if [[ $# -ne 2 ]] then
        echo "Usage: git.global.set-user <username> <email>"
        return 1
    fi
    git config --global user.name "$1"
    git config --global user.email "$2"
    git.config-summary
}
git.local.set-user() {
    if [[ $# -ne 2 ]] then
        echo "Usage: git.local.set-user <username> <email>"
        return 1
    fi
    git config --local user.name "$1"
    git config --local user.email "$2"
    git.config-summary
}
git.global.enable-auto-commit-signing() {
    # auto sign all commits
    git config --global commit.gpgsign true
    # use ssh key to sign commits
    git config --global gpg.format ssh
    git config --global gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers
    git config --global user.signingkey ~/.ssh/id_ed25519.pub
    # git log show signature by default 
    git config --global log.showSignature true
    #
    git.config-summary
}
git.global.edit-config() {
    [[ -f "$HOME/.gitconfig" ]] || { echo "Error: Global .gitconfig not found."; exit 1; }
    ${EDITOR:-vi} "$HOME/.gitconfig"
    git.config-summary
}
git.local.edit-config() {
    [[ -f ".git/config" ]] || { echo "Error: Local .git/config not found."; exit 1; }
    ${EDITOR:-vi} ".git/config"
    git.config-summary
}

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
