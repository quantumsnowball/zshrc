ensure paru || return


# paru
alias pr=paru

alias paru.install='paru -S'
alias pri=paru.install

alias paru.search='paru -Ss'
alias prs=paru.search

alias paru.ls='paru -Q'
alias prls=paru.ls

alias paru.ls-grep='paru -Q | rg'
alias prrg=paru.ls-grep

alias paru.remove='paru -Rsu'
alias prrm=paru.remove

alias paru.update='paru -Sy && paru -Qu'
alias pru=paru.update

alias paru.upgrade='paru -Syu'
alias prup=paru.upgrade
