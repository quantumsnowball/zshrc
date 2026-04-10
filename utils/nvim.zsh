ensure nvim || return


# neovim
alias vi='nvim'
alias v='nvim'

# helpers
nvim.ai() {
    (
        mkdir -p /tmp/nvim.ai && 
        cd /tmp/nvim.ai &&
        nvim \
            -c "set noswapfile" \
            -c "lua vim.schedule(function() vim.fn.feedkeys(vim.api.nvim_replace_termcodes(\",A\", true, true, true)) end)"
    )
}
alias v.ai='nvim.ai'

nvim.lazy.rm-all-plugins () {
    lazy_dir=~/.local/share/nvim/lazy/
    read -q "confirm?Are you sure you want to remove all lazy plugins? (y/n): "
    [[ "$confirm" =~ ^[Yy]$ ]] && rm -rf $lazy_dir
    [[ -d ~/.local/share/nvim/lazy/ ]] || echo "\n$lazy_dir has been deleted. Please reinstall all plugins again."
}
