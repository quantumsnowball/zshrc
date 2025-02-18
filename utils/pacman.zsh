installed pacman || return


# pacman
alias pm=pacman

alias pm.install='sudo pacman -S'
alias pmi=pm.install

alias pm.search='pacman -Ss'
alias pms=pm.search

alias pm.ls='pacman -Q'
alias pmls=pm.ls

alias pm.ls-grep='pacman -Q | rg'
alias pmrg=pm.ls-grep

alias pm.remove='sudo pacman -R'
alias pmrm=pm.remove

alias pm.update='sudo pacman -Sy && pacman -Qu'
alias pmu=pm.update

alias pm.upgrade='sudo pacman -Syu'
alias pmup=pm.upgrade

