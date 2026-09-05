[[ -d "$HOME/Projects/exkeymo/" ]] || return


exkeymo.start-local-builder-server() {
    (
        cd "$HOME/Projects/exkeymo/"
        python -m http.server 8080
    )
}

exkeymo.compile-kcm-to-apk() {
    # pass any args into compile.js
    node "$XDG_CONFIG_HOME/zshrc/utils/exkeymo/compiler/main.js" "$@"
}

exkeymo.use-kcm-layout() {
    local kcm_file="$1"
    # local output_apk="$TMPDIR/exkeymo.apk"
    local output_apk="$HOME/storage/downloads/exkeymo.apk"

    if [[ -z "$kcm_file" ]]; then
        echo "Usage: Exkeymo.compile-and-use-kcm-layout <input.kcm>" >&2
        return 1
    fi

    # Compile the layout to /tmp/output.apk
    exkeymo.compile-kcm-to-apk "$kcm_file" "$output_apk" || return 1

    # Trigger Android's package installer interface
    if [[ -f "$output_apk" ]]; then
        echo "Launching Android package installer..."
        termux-open "$output_apk"
    fi
}

