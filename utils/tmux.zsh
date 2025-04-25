ensure tmux || return


# tmux utils
alias tmux.create-new-session='tmux new -t'
alias tmux.list-sessions='tmux ls'
alias tmux.attach-to='tmux attach -t'
# short hand
alias t="tmux"
alias t.create-new-session=tmux.create-new-session
alias t.list-sessions=tmux.list-sessions
alias t.attach-to=tmux.attach-to
# even shorter
alias tn=tmux.create-new-session
alias tls=tmux.list-sessions
alias ta=tmux.attach-to
# helpers
alias ta0='tmux.attach-to 0'
