# if ssh-agent is not running, start it
# if ssh-agent is already running, find it
# anyway, will output the necessary env and eval it
# can accept any keychain args
keychain.start () {
    # in Termux, keychain failed to find running ssh-agent, probably no permission
    # in such case, can't depend on keychain to find ssh-agent, need to manually restore
    # first try to manually restore the env from ~/.keychain script
    [ -f ~/.keychain/$HOST-sh ] && source ~/.keychain/$HOST-sh

    # if reachable then exit here
    [ -S "$SSH_AUTH_SOCK" ] && zsocket "$SSH_AUTH_SOCK" 2>/dev/null && return

    # else use keychain normally
    eval $(keychain --eval $@)
}

# this is the most common use case, has to be short and handy
# call this in a new shell, or the current shell, or inside of lazygit 
# where ever necessary to add a key it should let most other shell instance 
# able to find the added key
keychain.add () {
    # normally boot up keychain
    keychain.start

    # then add default key or custom key
    ssh-add $1
}
alias kc=keychain.add

() {
    # namespaces
    local ns=(ssh sshd scp sftp keychain kc)

    #helpers
    alias ${^ns}.add-key='keychain.add'
}

#
# init
#

# start kc by default
# - start quietly ssh-agent quietly if not already running
# - find any existing ssh-agent and use it quietly
# - refresh the env so every shell should store updated env vars
# - initially don't ask for password, user can add key only when necessary
keychain.start
