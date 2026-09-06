# conditions to auto start tmux session
if [[
    # in Termux
    -n "$TERMUX_VERSION" && 
    # not inside tmux session
    -z "$TMUX" && 
    # not in an ssh session
    -z "$SSH_CONNECTION" &&
    -z "$SSH_CLIENT" &&
    # shell level equal 1
    "$SHLVL" -eq 1
]]; then
    # start or attach to session named 'main'
    tmux new-session -A -s main
fi
