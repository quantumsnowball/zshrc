installed pacman || return


# pacman
alias pacman.install='sudo pacman -S'
alias pmi=pacman.install

alias pacman.search='pacman -Ss'
alias pms=pacman.search

alias pacman.ls='pacman -Q'
alias pmls=pacman.ls

alias pacman.ls-grep='pacman -Q | rg'
alias pmrg=pacman.ls-grep

alias pacman.remove='sudo pacman -Rsu'
alias pmrm=pacman.remove

alias pacman.update='sudo pacman -Sy && pacman -Qu'
alias pmu=pacman.update

alias pacman.upgrade='sudo pacman -Syu'
alias pmup=pacman.upgrade


# update mirror list
ensure reflector || return


# mirror list
alias pacman.mirror.current='cat /etc/pacman.d/mirrorlist'
alias pacman.mirror.available='reflector'
alias pacman.mirror.hong-kong='reflector --country "Hong Kong"'
alias pacman.mirror.hong-kong.save-as-mirrorlist='sudo reflector --country "Hong Kong" --save /etc/pacman.d/mirrorlist'
