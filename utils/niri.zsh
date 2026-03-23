ensure niri || return


# BUG:
# The auto generated and installed _niri zfunc is located in /usr/share/zsh/site-functions/_niri
# However this version is buggy, causing the second completion being duplicated
# According to the officia Niri github issue, ref: 
# https://github.com/niri-wm/niri/issues/1682
# This is not a Niri bug, but a `clap_complete` bug, who is responsible for generating the completion
# The bug remains unfixed as of 2026-03-23, so here comes for a quickfix 
niri._completions_zsh_quickfix() {
    # This target_dir must be prepanded in front of the system fpath
    local target_dir="$HOME/.zfunc"
    local target_file="$target_dir/_niri"

    # Create directory if it doesn't exist
    mkdir -p "$target_dir"

    # Generate, apply fixes, and save
    # 1. Fixes the subcommand index [2] -> [1]
    # 2. Deletes the annoying CWD file listing line
    niri completions zsh | sed "s/line\[2\]/line[1]/g; /'::command/d" > "$target_file"

    if [[ -s "$target_file" ]]; then
        echo "✅ Fixed niri completion saved to $target_file"
        echo "🔄 Refreshing completion cache..."
        rm -f ~/.zcompdump*
        # Reload the function into the current session immediately
        unfunction _niri 2>/dev/null
        autoload -Uz _niri
        echo "🚀 Ready! Try 'niri msg <Tab>'"
    else
        echo "❌ Error: Failed to generate completion file."
    fi
}

# update niri socket url to latest
niri.refresh-ipc-socket-env() {
    # get the latest socket url value from /run/user/<id>/
    local socket
    socket=$(/bin/ls -t /run/user/$(id -u)/niri.wayland-*.sock 2>/dev/null | head -n 1)

    if [[ -n "$socket" ]]; then
        # 1. Fix the current shell
        export NIRI_SOCKET="$socket"
        
        # 2. Fix the tmux server global env vars for newer panes
        if [[ -n "$TMUX" ]]; then
            tmux set-environment -g NIRI_SOCKET "$socket"
        fi
        
        echo "Refreshed NIRI_SOCKET: $NIRI_SOCKET"
    else
        echo "Error: No niri socket found."
        return 1
    fi
}

