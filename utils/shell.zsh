# The stty sane command is a preset that resets the terminal settings to a reasonable and stable state.
stty sane
# sudo
if [[ -v TERMUX_VERSION ]]; then
    alias sudo=''
else
    alias sudo='sudo '
fi
alias root='/bin/sudo -E -s'
alias sudo.as='sudo -u'
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
# update system
up() {
    # ubuntu / termux
    installed apt && echo "\n${YELLOW}<<< apt update >>>${RESET}\n" && eval aptup
    # arch
    installed pacman && echo "\n${YELLOW}<<< pacman update >>>${RESET}\n" && eval pmup
    # snap
    installed snap && echo "\n${YELLOW}<<< snap update >>>${RESET}\n" && eval snapup
}
ups() {
    # update all packages
    eval up
    # sync configs
    echo "\n\n${YELLOW}<<< sync configs >>>${RESET}\n"
    eval s
}
alias u=ups
# fix enter key not working print ^M
alias zsh.fix_enter_key='stty sane'
