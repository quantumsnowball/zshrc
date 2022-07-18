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
        cf fetch ()
        {
            echo "echo \"\n# $1\n#\n\" && cd ~/.config/$1 && \
                git -c color.ui=always fetch --all && git -c color.ui=always status --short"
        }

        cf pull ()
        {
            echo "echo \"\n# $1\n#\n\" && cd ~/.config/$1 && \
                git -c color.ui=always pull --rebase --autostash"
        }

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
            echo "$(eval "$(fetch .repo)")" &
            echo "$(eval "$(fetch zshrc)")" &
            echo "$(eval "$(fetch nvim )")" &
            echo "$(eval "$(fetch tmux )")" &
            wait
            ;;
        fetch-sync | status-sync)
            (eval "$(fetch .repo)")
            (eval "$(fetch zshrc)")
            (eval "$(fetch nvim)")
            (eval "$(fetch tmux)")
            echo "\n"
            ;;
        pull)
            echo "$(eval "$(pull .repo)")" &
            echo "$(eval "$(pull zshrc)")" &
            echo "$(eval "$(pull nvim )")" &
            echo "$(eval "$(pull tmux )")" &
            wait
            ;;
        pull-sync)
            (eval "$(pull .repo)")
            (eval "$(pull zshrc)")
            (eval "$(pull nvim)")
            (eval "$(pull tmux)")
            echo "\n"
            ;;
        esac
    )
}
