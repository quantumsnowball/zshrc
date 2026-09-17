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

nvim.scratch()  {
     (
        mkdir -p /tmp/nvim.scratch && 
        cd /tmp/nvim.scratch &&
        nvim -c "lua vim.schedule(open_scratch_tabpage)"
     )
}
alias v.note='nvim.scratch'

nvim.lazy.rm-all-plugins () {
    lazy_dir=~/.local/share/nvim/lazy/
    read -q "confirm?Are you sure you want to remove all lazy plugins? (y/n): "
    [[ "$confirm" =~ ^[Yy]$ ]] && rm -rf $lazy_dir
    [[ -d ~/.local/share/nvim/lazy/ ]] || echo "\n$lazy_dir has been deleted. Please reinstall all plugins again."
}

nvim.download-word-alpha-dictionary() {
    wget -P "$XDG_CONFIG_HOME/nvim/.dictionary" "https://raw.github.com/dwyl/english-words/master/words_alpha.txt"
}

# install essential tools
nvim.install-essential-tools() {
    if [[ -v TERMUX_VERSION ]]; then
        # [tree-sitter]
        # termux version tree-sitter already include tree-sitter-cli
        pkg install tree-sitter
        pkg install \
            lua-language-server \
            ruff \
            rust-analyzer \
        ;
        pnpm install -g \
            bash-language-server \
            pyright \
            typescript-language-server \
            prettier \
        ;
        uv tool install \
            autopep8
        ;
    else
        # [tree-sitter]
        # linux tree-sitter includes tree-sitter-cli but need separate installation
        paru -S tree-sitter tree-sitter-cli
        paru -S lua-language-server \
            bash-language-server \
            pyright \
            autopep8 \
            ruff \
            typescript-language-server \
            prettier \
            rust-analyzer \
        ;
    fi
}
