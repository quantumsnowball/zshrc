ensure ssh || return


# patched command to ensure discovery of ssh-agent
ssh () {
    # try to make current shell to discover ssh-agent socket
    ssh-agent.reveal-socket &> /dev/null || true
    # execute the actual command
    command ssh "$@"
}


# ensure sshd is running on Termux
[ -v TERMUX_VERSION ] && sshd
