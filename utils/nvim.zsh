ensure nvim || return


# neovim
alias vi='nvim'
alias v='nvim'

nvim.lazy.rm-all-plugins () {
    $lazy_dir=~/.local/share/nvim/lazy/
    read -q "confirm?Are you sure you want to remove all lazy plugins? (y/n): "
    [[ "$confirm" =~ ^[Yy]$ ]] && rm -rf $lazy_dir
    [[ -d ~/.local/share/nvim/lazy/ ]] && echo "$lazy_dir has been deleted. Please reinstall all plugins again."
}
