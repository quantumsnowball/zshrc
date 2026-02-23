pager() {
    # Force colors for standard tools and Python/Ruff
    export CLICOLOR_FORCE=1
    export PY_COLORS=1
    export FORCE_COLOR=1 

    # Run the command and pipe to less
    # -c: Clear screen before painting
    # -S: Chop long lines (prevents wrapping mess)
    # -R: Repaint (shows colors)
    
    # if first word is an alias, run in newe zsh interactitve shell and get output
    if alias "$1" >/dev/null; then
        output=$(zsh -i -c "$@" 2>&1) 
        echo "$output" | less -cSR
    # if not an alias, then just run it in current shell as a normal command
    else
        "$@" 2>&1 | less -cSR
    fi
}
