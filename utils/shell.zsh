# sudo
if [[ -v TERMUX_VERSION ]]; then
    alias sudo=''
else
    alias sudo='sudo '
fi
alias root='/bin/sudo -E -s'
# clear
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
# completion
zsh.completion.toggle_dotfiles_visibility() {
    if [[ $options[globdots] == on ]]; then
        unsetopt globdots
        echo "zsh globdots: ${RED}DISABLED${YELLOW} (dotfiles will be hidden)${RESET}"
    else
        setopt globdots
        echo "zsh globdots: ${CYAN}ENABLED${YELLOW} (dotfiles will be shown)${RESET}"
    fi
}
# explorer.exe
alias ex=explorer.exe
alias ex.='explorer.exe .'
# update system
up() {
    # ubuntu / termux
    installed apt && echo '<<< apt update >>>' && aptup
    # arch
    installed pacman && echo '<<< pacman update >>>' && pmup
    # snap
    installed snap && echo '<<< snap update >>>' && snapup
}
alias ups='up; s'
