installed systemctl || return


# systemctl
alias sysd.status='systemctl status'
# - ls
alias sysd.system.ls.service.loaded='systemctl list-units --type=service'
alias sysd.system.ls.service.running='systemctl list-units --type=service --state=running'
alias sysd.system.ls.service.failed='systemctl list-units --type=service --state=failed'
alias sysd.system.ls.service='systemctl list-unit-files --type=service'
alias sysd.system.ls.everything.loaded='systemctl list-units --all'
alias sysd.system.ls.everything='systemctl list-unit-files --all'
alias sysd.user.ls.service.loaded='systemctl --user list-units --type=service'
alias sysd.user.ls.service.running='systemctl --user list-units --type=service --state=running'
alias sysd.user.ls.service.failed='systemctl --user list-units --type=service --state=failed'
alias sysd.user.ls.service='systemctl --user list-unit-files --type=service'
alias sysd.user.ls.everything.loaded='systemctl --user list-units --all'
alias sysd.user.ls.everything='systemctl --user list-unit-files --all'
# - action
alias sysd.system.restart='sudo systemctl restart'
alias sysd.system.reload='sudo systemctl reload'
alias sysd.system.start='sudo systemctl start'
alias sysd.system.stop='sudo systemctl stop'
alias sysd.system.enable='sudo systemctl enable'
alias sysd.system.disable='sudo systemctl disable'
alias sysd.system.edit='sudo -E systemctl edit'
alias sysd.system.daemon-reload='sudo systemctl daemon-reload'
alias sysd.user.restart='systemctl --user restart'
alias sysd.user.reload='systemctl --user reload'
alias sysd.user.start='systemctl --user start'
alias sysd.user.stop='systemctl --user stop'
alias sysd.user.enable='systemctl --user enable'
alias sysd.user.disable='systemctl --user disable'
alias sysd.user.edit='systemctl --user edit'
alias sysd.user.daemon-reload='systemctl --user daemon-reload'
# - profile
alias sysd.profiling='systemd-analyze critical-chain'

# journalctl
alias sysd.system.logs='journalctl'
alias sysd.system.logs-for='journalctl -u'
sysd.system.logs.clear () {
    sudo journalctl --rotate
    sudo journalctl --vacuum-time=1s
}
alias sysd.user.logs='journalctl --user'
alias sysd.user.logs-for='journalctl --user -u'
sysd.user.logs.clear () {
    journalctl --user --rotate
    journalctl --user --vacuum-time=1s
}
