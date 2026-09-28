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
alias r=zsh.reload-shell
zsh.resource-zshrc () {
    export ZSH_RESOURCING=true
    source ~/.zshrc
}
alias rr=zsh.resource-zshrc
# redo command
alias zsh.repeat-last-command='fc -e -'
alias rrr='fc -e -'
# reset completion cache
alias zsh.reset-completion-cache='rm ~/.zcompdump*'
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
    # termux environment check
    if [ -n "$TERMUX_VERSION" ]; then
        # link the asia mirror list
        echo "\n${YELLOW}<<< selected the asia mirror list >>>${RESET}\n"
        ln -sf "$PREFIX/etc/termux/mirrors/asia" "$PREFIX/etc/termux/chosen_mirrors"
        # run pkg install / upgrade
        echo "\n${YELLOW}<<< termux update >>>${RESET}\n"
        pkg upgrade
        return 0
    fi

    # cachyos
    if installed cachy-update; then
        echo "\n${YELLOW}<<< ranking cachyos mirrors >>>${RESET}\n"
        installed cachyos-rate-mirrors && sudo cachyos-rate-mirrors
        echo "\n${YELLOW}<<< cachy update >>>${RESET}\n"
        cachy-update
    # standard arch fallback
    elif installed pacman; then
        echo "\n${YELLOW}<<< ranking arch mirrors >>>${RESET}\n"
        if installed rate-mirrors; then
            rate-mirrors --save=/etc/pacman.d/mirrorlist arch
        elif installed reflector; then
            sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
        fi
        echo "\n${YELLOW}<<< pacman update >>>${RESET}\n"
        sudo pacman -Syu
    fi

    # ubuntu / debian
    if installed apt; then
        echo "\n${YELLOW}<<< apt update >>>${RESET}\n"
        sudo apt update && sudo apt upgrade
    fi

    # snap
    if installed snap; then
        echo "\n${YELLOW}<<< snap update >>>${RESET}\n"
        sudo snap refresh
    fi
}
u() { up; }
u.sync-sequencial() {
    # do a update on this remote list
    local remotes=(s7 a9 a56 quest2 vpn proxy)
    for remote in "${remotes[@]}"; do
        print -P "\n\n%F{cyan}%B┌─[ Remote: %F{yellow}$remote%F{cyan} ]"
        print -P "└───────────────────────────────────────────────────%b%f\n"
        # launch via a zsh interactive shell
        ssh -t "$remote" 'zsh -i -c up'
    done
}
u.sync() {
    local session_name="update-all"
    local remotes=(cachy s7 a9 a56 quest2 vpn proxy)

    # create new tmux session holding the first command
    tmux new-session -d -s "$session_name" -n "${remotes[1]}" "ssh -t ${remotes[1]} 'zsh -i -c up'; exec zsh"
    # add the remaining commands to new tmux windows
    for remote in "${remotes[@]:1}"; do
        tmux new-window -t "$session_name:" -n "$remote" "ssh -t $remote 'zsh -i -c up'; exec zsh"
    done
    # switch to or attach to the new session to see the result
    if [[ -n "$TMUX" ]]; then
        tmux switch-client -t "$session_name"
    else
        tmux attach-session -t "$session_name"
    fi
}
alias ua='u.sync'
# fix enter key not working print ^M
alias zsh.fix_enter_key='stty sane'
