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
            echo "$(echo "\n# .repo\n#\n" && cd ~/.config/.repo && \
                git -c color.ui=always fetch --all && git -c color.ui=always status --short)" &
            echo "$(echo "\n# zshrc\n#\n" && cd ~/.config/zshrc && \
                git -c color.ui=always fetch --all && git -c color.ui=always status --short)" &
            echo "$(echo "\n# nvim \n#\n" && cd ~/.config/nvim  && \
                git -c color.ui=always fetch --all && git -c color.ui=always status --short)" &
            echo "$(echo "\n# tmux \n#\n" && cd ~/.config/tmux  && \
                git -c color.ui=always fetch --all && git -c color.ui=always status --short)" &
            wait
            ;;
        fetch-sync | status-sync)
            (echo "\n# .repo\n#\n" && cd ~/.config/.repo && git fetch --all && git status --short)
            (echo "\n# zshrc\n#\n" && cd ~/.config/zshrc && git fetch --all && git status --short)
            (echo "\n# nvim \n#\n" && cd ~/.config/nvim  && git fetch --all && git status --short)
            (echo "\n# tmux \n#\n" && cd ~/.config/tmux  && git fetch --all && git status --short)
            echo "\n"
            ;;
        pull)
            echo "$(echo "\n# .repo\n#\n" && cd ~/.config/.repo && \
                git -c color.ui=always pull --rebase --autostash)" &
            echo "$(echo "\n# zshrc\n#\n" && cd ~/.config/zshrc && \
                git -c color.ui=always pull --rebase --autostash)" &
            echo "$(echo "\n# nvim \n#\n" && cd ~/.config/nvim  && \
                git -c color.ui=always pull --rebase --autostash)" &
            echo "$(echo "\n# tmux \n#\n" && cd ~/.config/tmux  && \
                git -c color.ui=always pull --rebase --autostash)" &
            wait
            ;;
        pull-sync)
            (echo "\n# .repo\n#\n" && cd ~/.config/.repo && git pull --rebase --autostash)
            (echo "\n# zshrc\n#\n" && cd ~/.config/zshrc && git pull --rebase --autostash)
            (echo "\n# nvim \n#\n" && cd ~/.config/nvim  && git pull --rebase --autostash)
            (echo "\n# tmux \n#\n" && cd ~/.config/tmux  && git pull --rebase --autostash)
            echo "\n"
            ;;
        esac
    )
}
