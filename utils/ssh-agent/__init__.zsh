#
# This is a modified version of the om-my-zsh ssh-agent plugins
# src: https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/ssh-agent/ssh-agent.plugin.zsh
#

# don't load anything if missing ~/.ssh/ 
[ -d "$HOME/.ssh" ] || return


# imports
zmodload zsh/net/socket


# list added keys
alias ssh-agent.ls-added-keys='ssh-add -l'
alias sshls=ssh-agent.ls-added-keys

# kill ssh-agent
alias ssh-agent.kill='killall -v ssh-agent'
alias sshkill=ssh-agent.kill
alias sshlock=ssh-agent.kill

# ssh-agent ready test
ssh-agent.test-socket () {
    # 1. must have a $SSH_AUTH_SOCK env vars
    # 2. the socket path must be reachable
    [ -S "$SSH_AUTH_SOCK" ] && zsocket "$SSH_AUTH_SOCK" 2>/dev/null
}

# make ssh-agent socket discoverable
ssh-agent.reveal-socket () {
    # if ssh-agent has started before, this will update the env socket path
    [ -f ~/.ssh/.env ] && . ~/.ssh/.env > /dev/null
}

# start agent
function ssh-agent.start() {
    # ensure setup env script exists, then try to restore it
    ssh-agent.reveal-socket
    # if env is restored, test the socket, if ready exit nicely
    ssh-agent.test-socket && return 0

    # if we're here, ssh-agent is not ready yet, need to recreate it

    # start new ssh-agent ps, but cache the setup env script first
    ssh-agent -s | sed '/^echo/d' >! ~/.ssh/.env
    # finally execute the script to create the new environment
    chmod 600 ~/.ssh/.env
    . ~/.ssh/.env > /dev/null

    # confirm the socket is ready again
    ssh-agent.test-socket && echo "ssh-agent is running"
}
alias sshs=ssh-agent.start

# add default keys
ssh-agent.add-keys () {
    # if ssh-agent socket is down, stat it first
    ssh-agent.test-socket || ssh-agent.start
    # ssh-add shoud then working normally, will scan ~/.ssh for default key names
    ssh-add "$@"
}
alias ssha=ssh-agent.add-keys

# install patched version of which can auto discover ssh-agent
ssh-agent.install-patched.git () {
    chmod 755 ~/.config/zshrc/utils/ssh-agent/patched/git
    ln -sf ~/.config/zshrc/utils/ssh-agent/patched/git ~/.local/bin/git &&
    ls -l ~/.local/bin/git
}

# ensure started ssh-agent on shell launch
ssh-agent.start
