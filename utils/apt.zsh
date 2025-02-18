installed apt || return


# apt
alias apt.install='sudo apt install'
alias apti=apt.install

alias apt.search='apt search'
alias apts=apt.search

alias apt.ls='apt list'
alias aptls=apt.ls

alias apt.ls-grep='apt list | rg'
alias aptrg=apt.ls-grep

alias apt.remove='sudo apt remove'
alias aptrm=apt.remove

alias apt.update='sudo apt update'
alias aptu=apt.update

alias apt.upgrade='sudo apt update && sudo apt upgrade'
alias apt.up=apt.upgrade

