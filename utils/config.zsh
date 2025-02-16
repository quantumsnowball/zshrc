# alias
alias s='cf pull'
alias cfp='cf pull'

# nvim editor config repos directly
cf ()
{
    # run in a subshell
    # - can retain current directory
    # - can avoid printing the & [1] <PID> and + done debug message 
    (
        status ()
        {
            echo "$(
                echo "\n#\n# < $1 >\n#" &&
                cd ~/.config/$1 2>&1 &&
                git -c color.ui=always status --short --branch 2>&1
            )"
        }
        fetch ()
        {
            echo "$(
                echo "\n#\n# < $1 >\n#" &&
                cd ~/.config/$1 2>&1 &&
                git -c color.ui=always fetch --all 2>&1 && 
                git -c color.ui=always status --short --branch 2>&1
            )"
        }
        pull ()
        {
            echo "$(
                echo "\n#\n# < $1 >\n#" &&
                cd ~/.config/$1 2>&1 &&
                git -c color.ui=always pull --rebase --autostash 2>&1
            )"
        }


        case $1 in
        status)
            status settings & 
            status zshrc & 
            status nvim & 
            status tmux & 
            status ssh & 
            wait
            ;;
        fetch)
            fetch settings & 
            fetch zshrc & 
            fetch nvim & 
            fetch tmux & 
            fetch ssh & 
            wait
            ;;
        pull)
            pull settings & 
            pull zshrc & 
            pull nvim & 
            pull tmux & 
            pull ssh & 
            wait
            source ~/.zshrc
            ;;
        set | setting | settings | conf | config)
            cd ~/.config/settings/ && nvim
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
