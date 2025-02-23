ensure keychain || return


keychain.start () {
    # if ssh-agent is not running, start it
    # if ssh-agent is already running, find it
    # anyway, will output the necessary env and eval it
    eval $(keychain --eval)
}
alias kc=keychain.start

