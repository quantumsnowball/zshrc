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
