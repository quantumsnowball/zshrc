ensure keychain || return


kc.start () {
    # if ssh-agent is not running, start it
    # if ssh-agent is already running, find it
    # anyway, will output the necessary env and eval it
    # can accept any keychain args
    eval $(keychain --eval $@)
}

# this is the most common usecase, has to be short and handy
# call this in a new shell, or the current shell, or inside of lazygiit 
# whereever necessary to add a key it should let most other shell instance 
# able to find the added key
kc.add () {
    # normally boot up keychain
    eval $(keychain --eval --quiet)
    # then add default keys
    ssh-add
}
alias kc=kc.add


#
# init
#

# in Termux, keychain failed to find running ssh-agent, probably no permission
# in such case, can't depend on keychain to find ssh-agent, need to manually restore
if [ -v TERMUX_VERSION ]; then
▎   # first try to manually restore the env from ~/.keychain script
▎   [ -f ~/.keychain/$HOST-sh ] && source ~/.keychain/$HOST-sh
▎
▎   # then test the socket,
▎   # if reachable then exit here, else keychain normally
▎   # if [ -S "$SSH_AUTH_SOCK" ] && zsocket "$SSH_AUTH_SOCK" 2>/dev/null; then
▎   #     echo rerusing agent
▎   #     return
▎   # fi
▎   return
fi

# start kc by default
# - start quietly ssh-agent quietly if not alreay running
# - find any existing ssh-agent and use it quietly
# - refresh the env so every shell should store updated env vars
# - initially don't ask for password, user can add key only when necessary
echo creating new agent
eval $(keychain --eval --quiet)
