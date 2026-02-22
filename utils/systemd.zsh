installed systemctl || return


# systemctl
alias sysd.status='systemctl status'
alias sysd.ls.enabled='systemctl list-unit-files --state=enabled'
alias sysd.ls.disabled='systemctl list-unit-files --state=disabled'
alias sysd.ls.all='systemctl list-unit-files'
alias sysd.ls='sysd.ls.enabled'
alias sysd.ls-grep='systemctl list-unit-files | rg'
sysd.restart-service () {
    sudo systemctl restart $1
}
sysd.start-service () {
    sudo systemctl start $1
}
sysd.stop-service () {
    sudo systemctl start $1
}
sysd.enable-service () {
    sudo systemctl enable $1
}
sysd.disable-service () {
    sudo systemctl disable $1
}
sysd.daemon-reload () {
    sudo systemctl daemon-reload
}

# journalctl
alias sysd.log='journalctl'
sysd.log-for () {
    journalctl -u $1
}
sysd.log.clear () {
    sudo journalctl --rotate
    sudo journalctl --vacuum-time=1s
}
