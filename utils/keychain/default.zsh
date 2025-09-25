# if ssh-agent is not running, start it
# if ssh-agent is already running, find it
# anyway, will output the necessary env and eval it
# can accept any keychain args
kc.start () {
    eval $(keychain --eval $@)
}

# this is the most common use case, has to be short and handy
# call this in a new shell, or the current shell, or inside of lazygit 
# where ever necessary to add a key it should let most other shell instance 
# able to find the added key
kc.add () {
    # normally boot up keychain
    eval $(keychain --eval --quiet)

    # then add default key or custom key
    ssh-add $1
}
alias kc=kc.add


# start kc by default
# - start quietly ssh-agent quietly if not already running
# - find any existing ssh-agent and use it quietly
# - refresh the env so every shell should store updated env vars
# - initially don't ask for password, user can add key only when necessary
eval $(keychain --eval --quiet)

