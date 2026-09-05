ensure tmux || return


# short hand
alias t='tmux attach -t 0 || tmux new -s 0'

() {
    # namespaces
    local ns=(t tmux)

    # tmux utils
    alias ${^ns}.create-new-session='tmux new -t'
    alias ${^ns}.list-sessions='tmux ls'
    alias ${^ns}.attach-to='tmux attach -t'
    alias ${^ns}.attach-to-0='tmux attach -t 0'
}
