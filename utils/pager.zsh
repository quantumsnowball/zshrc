pager() {
    # Force colors for standard tools and Python/Ruff
    export CLICOLOR_FORCE=1
    export PY_COLORS=1
    export FORCE_COLOR=1 

    # Run the command and pipe to less
    # -c: Clear screen before painting
    # -S: Chop long lines (prevents wrapping mess)
    # -R: Repaint (shows colors)
    "$@" | less -c -S -R
}

# Tell zsh that 'pager' is a wrapper that follows its first argument
# compdef _precommand pager
