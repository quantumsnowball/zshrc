ensure git || return


# nvim editor config repos directly
# NOTE: run in a subshell can retain current directory
cf () {
    (
        case $1 in
            setting | settings)
                cd ~/.config/settings/ && nvim
                ;;
            shared )
                cd ~/.config/settings-shared/ && nvim
                ;;
            nvim | neovim)
                cd ~/.config/nvim && nvim
                ;;
            zsh | zshrc)
                cd ~/.config/zshrc && nvim
                ;;
            posh | poshrc)
                cd ~/.config/poshrc && nvim
                ;;
            tmux)
                cd ~/.config/tmux && nvim
                ;;
            ssh)
                cd ~/.config/ssh && nvim
                ;;
            winterm)
                cd ~/winhost/home/AppData/Local/Packages/Microsoft.WindowsTerminal_*/LocalState/ && nvim settings.json
                ;;
        esac
    )
}


# utils helpers
cf.status () {
    [ -d ~/.config/$1 ] &&
    echo "$(
        echo "#\n# < $1 >\n#" &&
        cd ~/.config/$1 2>&1 &&
        git -c color.ui=always status --short --branch 2>&1
    )\n"
}
cf.fetch () {
    [ -d ~/.config/$1 ] &&
    echo "$(
        echo "#\n# < $1 >\n#" &&
        cd ~/.config/$1 2>&1 &&
        git -c color.ui=always fetch --all 2>&1 && 
        git -c color.ui=always status --short --branch 2>&1
    )\n"
}
cf.pull () {
    [ -d ~/.config/$1 ] &&
    echo "$(
        echo "#\n# < $1 >\n#" &&
        cd ~/.config/$1 2>&1 &&
        git -c color.ui=always pull --rebase --autostash 2>&1 &&
        git -c color.ui=always status --short --branch 2>&1
    )\n"
}


# batch helpers
# NOTE: run in a subshell can avoid printing the & [1] <PID> and + done debug message 
cf.fetch-all () {
    (
        cf.fetch zshrc &
        cf.fetch nvim &
        cf.fetch tmux &
        cf.fetch settings &
        cf.fetch settings-shared &
        cf.fetch ssh &
        wait
    )
}
cf.pull-all () {
    (
        cf.pull zshrc &
        cf.pull nvim &
        cf.pull tmux &
        cf.pull settings &
        cf.pull settings-shared &
        cf.pull ssh &
        wait
    )
    # reload shell after pull
    zsh.reload-shell
}

# alias
alias s='cf.pull-all'
alias cfp='cf.pull-all'
alias cff='cf.fetch-all'
