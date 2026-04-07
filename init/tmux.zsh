ensure tmux || return


# Only run this if we are actually inside a tmux session
if [[ -n "$TMUX" ]]; then
    # Fired after hit Enter, to update the tmux window name 
    preexec() {
        # Get the full command
        local full_cmd="$1"
        # Trim leading/trailing whitespace
        full_cmd="${full_cmd#"${full_cmd%%[![:space:]]*}"}"
        # Truncate to 20 chars
        if (( ${#full_cmd} > 20 )); then
            full_cmd="${full_cmd[1,19]}…"
        fi
        # Update Tmux
        tmux rename-window "$full_cmd"
    }

    # Fired when the command finishes
    precmd() {
        # Reset window to emtpy single space
        tmux rename-window " "
    }
fi
