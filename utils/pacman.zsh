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

alias pm.remove='sudo pacman -Rsu'
alias pmrm=pm.remove

alias pm.update='sudo pacman -Sy && pacman -Qu'
alias pmu=pm.update

alias pm.upgrade='sudo pacman -Syu'
alias pmup=pm.upgrade


# update mirror list
ensure reflector || return


# mirror list
alias pm.mirror.current='cat /etc/pacman.d/mirrorlist'
alias pm.mirror.available='reflector'
alias pm.mirror.hong-kong='reflector --country "Hong Kong"'
alias pm.mirror.hong-kong.save-as-mirrorlist='sudo reflector --country "Hong Kong" --save /etc/pacman.d/mirrorlist'
