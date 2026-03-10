ensure kanata || return


alias kanata.devices='kanata --list'
alias kanata.check-config='kanata --check --cfg'
alias kanata.restart='systemctl restart --user kanata'
alias kanata.stop='systemctl stop --user kanata'
alias kanata.logs='journalctl --user -u kanata -f'
