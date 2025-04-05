ensure lazygit || return


# lazygit
lg () {
    # run in a subshell
    # - can retain current directory
    (
        # Define the base directory mapping
        local dir
        case $1 in
            set | setting | settings | conf | config)
                cd "$HOME/.config/settings" && shift && lazygit $@
                ;;
            vi | nvim | vim | neovim)
                cd "$HOME/.config/nvim" && shift && lazygit $@
                ;;
            zshrc | shell | zsh)
                cd "$HOME/.config/zshrc" && shift && lazygit $@
                ;;
            poshrc | posh)
                cd ~/winhome/Documents/WindowsPowerShell/poshrc && shift && lazygit $@
                ;;
            tmux)
                cd "$HOME/.config/tmux" && shift && lazygit $@
                ;;
            ssh)
                cd "$HOME/.config/ssh" && shift && lazygit $@
                ;;
            -h | --help)
                echo "lg\n  Usage:\n    lg {set|nvim|zsh|posh|tmux|ssh|-h} [lazygit-args]\n"
                lazygit --help
                ;;
            *)
                lazygit $@
                ;;
        esac
    )
}
