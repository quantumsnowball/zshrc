# sudo
if [[ -v TERMUX_VERSION ]]; then
    alias sudo=''
else
    alias sudo='sudo '
fi
alias root='/bin/sudo -E -s'
# clear
alias c=clear
alias cl=clear
# reload shell
zsh.reload-shell () {
    export ZSH_RELOADING=true
    exec zsh
}
alias rr=zsh.reload-shell
zsh.resource-zshrc () {
    export ZSH_RESOURCING=true
    source ~/.zshrc
}
alias rrr=zsh.resource-zshrc
# exit
alias x=exit
# process
alias jobs='jobs -l'
