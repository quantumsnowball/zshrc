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

    # tmux utils
    alias ${^ns}.create-new-session='tmux new -t'
    alias ${^ns}.list-sessions='tmux ls'
    alias ${^ns}.attach-to='tmux attach -t'
    alias ${^ns}.attach-to-0='tmux attach -t 0'
}
