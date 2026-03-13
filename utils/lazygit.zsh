ensure lazygit || return


# lazygit
g () {
    # run in a subshell
    # - can retain current directory
    (
        # Define the base directory mapping
        local dir
        case $1 in
            nvim | neovim)
                cd "$HOME/.config/nvim" && shift && lazygit $@
                ;;
            zsh | zshrc)
                cd "$HOME/.config/zshrc" && shift && lazygit $@
                ;;
            posh | poshrc)
                cd ~/winhome/Documents/WindowsPowerShell/poshrc && shift && lazygit $@
                ;;
            tmux)
                cd "$HOME/.config/tmux" && shift && lazygit $@
                ;;
            work | workspace)
                cd "$HOME/.config/workspace" && shift && lazygit $@
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
