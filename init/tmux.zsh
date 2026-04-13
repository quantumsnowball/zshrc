ensure tmux || return


# Only run this if we are actually inside a tmux session
if [[ -n "$TMUX" ]]; then
    # Fired after hit Enter, to update the tmux window name 
    preexec() {
        # Get the full command
        local full_cmd="$1"

        # Trim leading/trailing whitespace
        full_cmd="${full_cmd#"${full_cmd%%[![:space:]]*}"}"

        # Special Case: v or nvim, y or yazi
        local -a dir_context_cmds=(v nvim vi vim y yazi)
        local first_word="${full_cmd%% *}"
        # - the (r) flag searches for a match; if found, it returns the string
        if [[ -n "${dir_context_cmds[(r)$first_word]}" ]]; then
            local dir_name="${PWD##*/}"
            full_cmd="${first_word}:${dir_name}"
        fi

        # Truncate to 30 chars
        if (( ${#full_cmd} > 30 )); then
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
