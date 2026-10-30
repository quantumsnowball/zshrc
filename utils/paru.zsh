ensure paru || return


# common
alias paru.install='paru -S'
alias paru.search='paru -Ss'
alias paru.ls='paru -Q'
alias paru.remove='paru -Rsu'
alias paru.update='paru -Sy && paru -Qu'
alias paru.upgrade='paru -Syu'

# short hand
alias pri=paru.install
alias prs=paru.search
alias prls=paru.ls
alias prrm=paru.remove
alias pru=paru.update
alias prup=paru.upgrade
