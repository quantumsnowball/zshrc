ensure git || return


# nvim editor config repos directly
# NOTE: run in a subshell can retain current directory
dotconfig() {
    (
        case $1 in
            nvim | neovim)
                cd ~/.config/nvim && nvim
                ;;
            zsh | zshrc)
                cd ~/.config/zshrc && nvim
                ;;
            posh | poshrc)
                cd ~/.config/poshrc && nvim
                ;;
            tmux)
                cd ~/.config/tmux && nvim
                ;;
            work | workspace)
                cd ~/.config/workspace && nvim
                ;;
            pri | private | workspace-private | _work | work_ | _workspace | workspace_)
                cd ~/.config/workspace-private && nvim
                ;;
            winterm)
                cd ~/winhost/home/AppData/Local/Packages/Microsoft.WindowsTerminal_*/LocalState/ && nvim settings.json
                ;;
        esac
    )
}
c() { dotconfig $1; }


# Git config
dotconfig.git.remote-origin-urls() {
    (cd ~/.config/zshrc && git config --local remote.origin.url)
    (cd ~/.config/nvim && git config --local remote.origin.url)
    (cd ~/.config/tmux && git config --local remote.origin.url)
    (cd ~/.config/workspace && git config --local remote.origin.url)
    (cd ~/.config/workspace-private && git config --local remote.origin.url)
}
c.git.remote-origin-urls() { dotconfig.git.remote-origin-urls; }


# utils helpers
dotconfig.status() {
    [ -d ~/.config/$1 ] &&
    echo "$(
        echo "#\n# < $1 >\n#" &&
        cd ~/.config/$1 2>&1 &&
        git -c color.ui=always status --short --branch 2>&1
    )\n"
}
dotconfig.fetch() {
    [ -d ~/.config/$1 ] &&
    echo "$(
        echo "#\n# < $1 >\n#" &&
        cd ~/.config/$1 2>&1 &&
        git -c color.ui=always fetch --all 2>&1 && 
        git -c color.ui=always status --short --branch 2>&1
    )\n"
}
dotconfig.pull() {
    [ -d ~/.config/$1 ] &&
    echo "$(
        echo "#\n# < $1 >\n#" &&
        cd ~/.config/$1 2>&1 &&
        git -c color.ui=always pull --rebase --autostash 2>&1 &&
        git -c color.ui=always status --short --branch 2>&1
    )\n"
}


# batch helpers
dotconfig.fetch-all() {
    # run in a subshell can avoid printing the & [1] <PID> and + done debug message 
    (
        dotconfig.fetch zshrc &
        dotconfig.fetch nvim &
        dotconfig.fetch tmux &
        dotconfig.fetch workspace &
        dotconfig.fetch workspace-private &
        wait
    )
}
dotconfig.pull-all() {
    (
        dotconfig.pull zshrc &
        dotconfig.pull nvim &
        dotconfig.pull tmux &
        dotconfig.pull workspace &
        dotconfig.pull workspace-private &
        wait
    )
}
dotconfig.pull-all-and-reload-shell() {
    dotconfig.pull-all
    zsh.reload-shell
}
s() { dotconfig.pull-all; }
