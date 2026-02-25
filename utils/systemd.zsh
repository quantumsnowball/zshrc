installed systemctl || return


# systemctl
alias sysd.status='systemctl status'
alias sysd.ls.service.loaded='systemctl list-units --type=service'
alias sysd.ls.service.running='systemctl list-units --type=service --state=running'
alias sysd.ls.service.running-user='systemctl --user list-units --type=service --state=running'
alias sysd.ls.service.failed='systemctl list-units --type=service --state=failed'
alias sysd.ls.service.installed='systemctl list-unit-files --type=service'
alias sysd.ls.service.enabled='systemctl list-unit-files --type=service --state=enabled'
alias sysd.ls.service.disabled='systemctl list-unit-files --type=service --state=disabled'
alias sysd.ls.timers='systemctl list-timers'
alias sysd.ls.everything.loaded='systemctl list-units --all'
alias sysd.ls.everything.installed='systemctl list-unit-files --all'
alias sysd.find.service.loaded='systemctl list-units --type=service | rg'
alias sysd.find.service.installed='systemctl list-unit-files --type=service | rg'
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
