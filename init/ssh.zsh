ensure ssh || return


# ensure sshd is running on Termux
[ -v TERMUX_VERSION ] && sshd
