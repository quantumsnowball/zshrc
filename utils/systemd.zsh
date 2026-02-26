installed systemctl || return


# systemctl
alias sysd.status='systemctl status'
# ls
alias sysd.ls='sysd.ls.service.running'
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
# find
alias sysd.find.service.loaded='systemctl list-units --type=service | rg'
alias sysd.find.service.installed='systemctl list-unit-files --type=service | rg'
# action
sysd.restart() { sudo systemctl restart "$@" }
sysd.reload() { sudo systemctl reload "$@" }
sysd.start() { sudo systemctl start "$@" }
sysd.stop() { sudo systemctl stop "$@" }
sysd.enable() { sudo systemctl enable "$@" }
sysd.disable() { sudo systemctl disable "$@" }
sysd.reload-daemon () { sudo systemctl daemon-reload }
sysd.edit () { sudo -E systemctl edit "$@" }
# profile
alias sysd.profiling='systemd-analyze critical-chain'

# journalctl
sysd.logs() { journalctl "$@" }
sysd.logs-for () { journalctl -u "$@" }
sysd.logs.clear () {
    sudo journalctl --rotate
    sudo journalctl --vacuum-time=1s
}
