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
alias rr='exec zsh'
alias rl=rr
# exit
alias x=exit
# process
alias jobs='jobs -l'
