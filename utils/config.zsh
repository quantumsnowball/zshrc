# nvim editor config repos directly
cf ()
{
    # run in a subshell to retain current directory
    (
        cf status ()
        {
            echo "echo \"\n# $1\n#\n\" && cd ~/.config/$1 && \
                git -c color.ui=always status --short --branch"
        }

        cf fetch ()
        {
            echo "echo \"\n# $1\n#\n\" && cd ~/.config/$1 && \
                git -c color.ui=always fetch --all && git -c color.ui=always status --short --branch"
        }

        cf pull ()
        {
            echo "echo \"\n# $1\n#\n\" && cd ~/.config/$1 && \
                git -c color.ui=always pull --rebase --autostash"
        }

        cf push ()
        {
            echo "echo \"\n# $1\n#\n\" && cd ~/.config/$1 && \
                git -c color.ui=always push"
        }

        cf sync ()
        {
            echo "echo \"\n# $1\n#\n\" && cd ~/.config/$1 && \
                git pull --rebase --autostash --quiet && git push --quiet && git -c color.ui=always status --short --branch"
        }

        case $1 in
        set | setting | settings | conf | config)
            cd ~/.config/settings/ && nvim
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
        status)
            echo "$(eval "$(status settings)")" &
            echo "$(eval "$(status zshrc)")" &
            echo "$(eval "$(status nvim )")" &
            echo "$(eval "$(status tmux )")" &
            wait
            ;;
        fetch)
            echo "$(eval "$(fetch settings)")" &
            echo "$(eval "$(fetch zshrc)")" &
            echo "$(eval "$(fetch nvim )")" &
            echo "$(eval "$(fetch tmux )")" &
            wait
            ;;
        fetch-sync | status-sync)
            (eval "$(fetch settings)")
            (eval "$(fetch zshrc)")
            (eval "$(fetch nvim)")
            (eval "$(fetch tmux)")
            echo "\n"
            ;;
        pull)
            echo "$(eval "$(pull settings)")" &
            echo "$(eval "$(pull zshrc)")" &
            echo "$(eval "$(pull nvim )")" &
            echo "$(eval "$(pull tmux )")" &
            wait
            ;;
        pull-sync)
            (eval "$(pull settings)")
            (eval "$(pull zshrc)")
            (eval "$(pull nvim)")
            (eval "$(pull tmux)")
            echo "\n"
            ;;
        push)
            echo "$(eval "$(push settings)")" &
            echo "$(eval "$(push zshrc)")" &
            echo "$(eval "$(push nvim )")" &
            echo "$(eval "$(push tmux )")" &
            wait
            ;;
        sync)
            echo "$(eval "$(sync settings)")" &
            echo "$(eval "$(sync zshrc)")" &
            echo "$(eval "$(sync nvim )")" &
            echo "$(eval "$(sync tmux )")" &
            wait
            ;;
        esac
    )
}
