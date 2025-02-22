ensure ssh || return


# patched command to ensure discovery of ssh-agent
ssh () {
    # try to load ssh-agent setup-env script
    [ -f ~/.ssh/.env ] && . ~/.ssh/.env
    # execute the actual command
    command ssh "$@"
}


# ensure sshd is running on Termux
[ -v TERMUX_VERSION ] && sshd
