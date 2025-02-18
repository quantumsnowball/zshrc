# nvim editor config repos directly
cf () {
    (
        case $1 in
            set | setting | settings | conf | config)
            cd ~/.config/settings/ && nvim
            ;;
        shared )
            cd ~/.config/settings-shared/ && nvim
            ;;
        vi | nvim | vim | neovim)
            cd ~/.config/nvim && nvim
            ;;
        zshrc | shell | zsh)
            cd ~/.config/zshrc && nvim
            ;;
        poshrc | posh)
            cd ~/.config/poshrc && nvim
            ;;
        tmux)
            cd ~/.config/tmux && nvim
            ;;
        ssh)
            cd ~/.config/ssh && nvim
            ;;
        ala | alacritty)
            cd ~/.config/alacritty && nvim alacritty.yml
            ;;
        esac
    )
}


# utils helpers
cf.status () {
    echo "$(
        [ -d ~/.config/$1 ] &&
        echo "\n#\n# < $1 >\n#" &&
        cd ~/.config/$1 2>&1 &&
        git -c color.ui=always status --short --branch 2>&1
    )"
}
cf.fetch () {
    echo "$(
        [ -d ~/.config/$1 ] &&
        echo "\n#\n# < $1 >\n#" &&
        cd ~/.config/$1 2>&1 &&
        git -c color.ui=always fetch --all 2>&1 && 
        git -c color.ui=always status --short --branch 2>&1
    )"
}
cf.pull () {
    echo "$(
        [ -d ~/.config/$1 ] &&
        echo "\n#\n# < $1 >\n#" &&
        cd ~/.config/$1 2>&1 &&
        git -c color.ui=always pull --rebase --autostash 2>&1
    )"
}


# batch helpers
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
    source ~/.zshrc &&
    echo "\nINFO: ~/.zshrc reloaded\n"
}

