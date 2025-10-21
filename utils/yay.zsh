installed yay || return


# pacman
alias yay.install='sudo yay -S'
alias yayi=yay.install

alias yay.search='yay -Ss'
alias yays=yay.search

alias yay.ls='yay -Q'
alias yayls=yay.ls

alias yay.ls-grep='yay -Q | rg'
alias yayrg=yay.ls-grep

alias yay.remove='yay -R'
alias yayrm=yay.remove

alias yay.update='yay -Sy && yay -Qu'
alias yayu=yay.update

alias yay.upgrade='yay -Syu'
alias yayup=yay.upgrade

