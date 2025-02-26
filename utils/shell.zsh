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
alias q=exit
# process
alias jobs='jobs -l'
# profiling
alias zsh.time-startup='time zsh -i -c exit'
alias zsh.profiling-startup='ZDOTDIR=~/.config/zshrc/profiling/ zsh -i -c exit | less -c -S'
