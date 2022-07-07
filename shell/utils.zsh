# mkdir and then cd into it in one command
mkcd ()
{
    mkdir -p -- "$1" && cd -P -- "$1" 
}

# nvim editor config repos directly
cf ()
{
    # run in a subshell to retain current directory
    (
        case $1 in
        repo | .repo | conf | config)
            cd ~/.config/.repo/ && nvim
            ;;
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
        fetch | status)
            (echo "\nfetching .repo ..." && cd ~/.config/.repo && git fetch --all && git status --short)
            (echo "\nfetching zshrc ..." && cd ~/.config/zshrc && git fetch --all && git status --short)
            (echo "\nfetching nvim ..." && cd ~/.config/nvim && git fetch --all && git status --short)
            (echo "\nfetching tmux ..." && cd ~/.config/tmux && git fetch --all && git status --short)
            ;;
        pull)
            (echo "\npulling .repo ..." && cd ~/.config/.repo && git pull --rebase)
            (echo "\npulling zshrc ..." && cd ~/.config/zshrc && git pull --rebase)
            (echo "\npulling nvim ..." && cd ~/.config/nvim && git pull --rebase)
            (echo "\npulling tmux ..." && cd ~/.config/tmux && git pull --rebase)
            echo "\n"
            ;;
        esac
    )
}
