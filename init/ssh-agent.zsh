#
# This is a modified version of the om-my-zsh ssh-agent plugins
# src: https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/ssh-agent/ssh-agent.plugin.zsh
#

# don't load anything if missing ~/.ssh/ 
[ -d "$HOME/.ssh" ] || return


# helpers
alias ssh-agent.ls-added-keys='ssh-add -l'
alias sshls=ssh-agent.ls-added-keys

alias ssh-agent.kill='killall ssh-agent'
alias sshkill=ssh-agent.kill
alias sshlock=ssh-agent.kill

# this will auto discover and add keys
alias ssh-agent.add-keys='ssh-add'
alias ssha=ssh-agent.add-keys

function ssh-agent.start() {
    # ensure setup-env script exists, then try to restore it
    if [ -f ~/.ssh/.env ] && . ~/.ssh/.env > /dev/null; then
        # if env is restored, test the socket
        zmodload zsh/net/socket
        if [ -S "$SSH_AUTH_SOCK" ] && zsocket "$SSH_AUTH_SOCK" 2>/dev/null; then
            # socket is valid, ssh-agent is ready
            return 0
        fi
    fi

    #
    # if we're here, ssh-agent is not ready yet, need to recreate it
    #

    # start new ssh-agent ps, but cache the setup env script first
    ssh-agent -s | sed '/^echo/d' >! ~/.ssh/.env
    # finally execute the script to create the new environment
    chmod 600 ~/.ssh/.env
    . ~/.ssh/.env > /dev/null
    echo "ssh-agent is running"
}
alias sshs=ssh-agent.start

# ensure started ssh-agent on shell launch
ssh-agent.start
