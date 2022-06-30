# mkdir and then cd into it in one command
mkcd ()
{
    mkdir -p -- "$1" && cd -P -- "$1" 
}

cf ()
{
    case $1 in
    vi | nvim | vim | neovim)
        cd ~/.config/nvim && nvim
        ;;
    zshrc | shell | zsh)
        cd ~/.config/zshrc && nvim
        ;;
    tmux)
        cd ~/.config/tmux && nvim
        ;;
    ala | alacritty)
        cd ~/.config/alacritty && nvim alacritty.yml
        ;;
    esac
}
