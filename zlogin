# In Termux, auto-start tmux on initial login, returning to native Zsh on detach
if [[ -n "$TERMUX_VERSION" && -z "$TMUX" && "$SHLVL" -eq 1 ]]; then
    tmux new-session -A -s main
fi
