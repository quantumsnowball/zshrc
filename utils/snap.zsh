installed snap || return


# apt
alias snap.install='sudo snap install'
alias snapi=snap.install

alias snap.search='snap search'
alias snaps=snap.search

alias snap.ls='snap list'
alias snapls=snap.ls

alias snap.ls-grep='snap list | rg'
alias snapgrep=snap.ls-grep
alias snaprg=snap.ls-grep

alias snap.remove='sudo snap remove'
alias snaprm=snap.remove

alias snap.update='snap refresh --list'
alias snapu=snap.update

alias snap.upgrade='sudo snap refresh'
alias snapup=snap.upgrade

