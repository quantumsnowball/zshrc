ensure tmux || return


# smart tmux attach / create helper function
t() {
    # us $1 as target name, default ot main
    local target="${1:-main}"

    # inside tmux
    if [[ -n "$TMUX" ]]; then
        # create target session if missing
        tmux has-session -t "$target" 2>/dev/null || tmux new-session -d -s "$target"
        # then switch to it
        tmux switch-client -t "$target"
    # outside tmux
    else
        # attach to target session, or create it if missing
        tmux new-session -A -s "$target"
    fi
}


() {
    # namespaces
    local ns=(t tmux)

    # create
    alias ${^ns}.go-to='t'
    alias ${^ns}.ls='tmux list-sessions'
    alias ${^ns}.list-sessions='tmux list-sessions'
    # manage
    alias ${^ns}.tree-overview='tmux choose-tree'
    alias ${^ns}.rename-session='tmux rename-session'
    alias ${^ns}.rename-window='tmux rename-window'
    alias ${^ns}.kill-session='tmux kill-session -t'
    # detach
    alias ${^ns}.detach='tmux detach-client'
    alias ${^ns}.quit='tmux detach-client'
    alias ${^ns}.exit='tmux detach-client'
    # kill
    alias ${^ns}.reset-everything='tmux kill-server'
    # config
    alias ${^ns}.reload-config='tmux source-file ~/.config/tmux/tmux.conf'
}
