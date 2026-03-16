ensure paru || return


# paru
alias pr=paru

alias pr.install='paru -S'
alias pri=pr.install

alias pr.search='paru -Ss'
alias prs=pr.search

alias pr.ls='paru -Q'
alias prls=paru.ls

alias pr.ls-grep='paru -Q | rg'
alias prrg=pr.ls-grep

alias pr.remove='paru -Rsu'
alias prrm=pr.remove

alias pr.update='paru -Sy && paru -Qu'
alias pru=pr.update

alias pr.upgrade='paru -Syu'
alias prup=pr.upgrade
