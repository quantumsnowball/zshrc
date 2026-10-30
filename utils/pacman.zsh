installed pacman || return


# common
alias pacman.install='sudo pacman -S'
alias pacman.search='pacman -Ss'
alias pacman.ls='pacman -Q'
alias pacman.remove='sudo pacman -Rsu'
alias pacman.update='sudo pacman -Sy && pacman -Qu'
alias pacman.upgrade='sudo pacman -Syu'

# short hand
alias pmi=pacman.install
alias pms=pacman.search
alias pmls=pacman.ls
alias pmrm=pacman.remove
alias pmu=pacman.update
alias pmup=pacman.upgrade


# update mirror list
ensure reflector || return


# mirror list
alias pacman.mirror.current='cat /etc/pacman.d/mirrorlist'
alias pacman.mirror.available='reflector'
alias pacman.mirror.hong-kong='reflector --country "Hong Kong"'
alias pacman.mirror.hong-kong.save-as-mirrorlist='sudo reflector --country "Hong Kong" --save /etc/pacman.d/mirrorlist'
