ensure keychain || return


keychain.start () {
    # if ssh-agent is not running, start it
    # if ssh-agent is already running, find it
    # anyway, will output the necessary env and eval it
    # can accept any keychain args
    eval $(keychain --eval $@)
}
alias kc.start=keychain.start

keychain.add () {
    # normally boot up keychain
    eval $(keychain --eval --quiet)
    # then add default keys
    ssh-add
}
alias kc=keychain.add

# start kc by default
# - start quietly ssh-agent quietly if not alreay running
# - find any existing ssh-agent and use it quietly
# - refresh the env so every shell should store updated env vars
# - initially don't ask for password, user can add key only when necessary
eval $(keychain --eval --quiet)
