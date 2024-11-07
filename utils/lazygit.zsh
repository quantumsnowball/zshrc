# lazygit
lg () {
    # run in a subshell
    # - can retain current directory
    (
        # Define the base directory mapping
        local dir
        case $1 in
            vi | nvim | vim | neovim)
                cd "$HOME/.config/nvim" && shift && lazygit $@
                ;;
            *)
                lazygit
                ;;
        esac
    )
}
