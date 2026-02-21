ensure sshd || return


# start/stop service
alias sshd.start='sudo $(which sshd)'
alias sshd.stop='sudo pkill -f sshd'

# clients connection status
alias sshd.clients='ss -tnp state established'
