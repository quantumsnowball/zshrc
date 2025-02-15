# global vars
NOT_YET_INSTALL=""


# check if binary exists in PATH
installed () {
    command -v "$1" 2>&1 >/dev/null
}

# helper to be used as a guarding statement, put at first line of a script file: 
#   ensure <binary name> || return
ensure () {
    if installed $1; then
        return 0
    else
        NOT_YET_INSTALL="$NOT_YET_INSTALL $1"
        return 1
    fi
}


# suggest user what to install next
wtf-to-install () {
    echo $NOT_YET_INSTALL | xargs
}

