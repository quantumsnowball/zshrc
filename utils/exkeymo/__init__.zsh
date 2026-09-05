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
    local input_kcm="$1"
    local output_apk="$TMPDIR/exkeymo-layout-cache.apk"

    # ensure 
    if [[ ! -f "$input_kcm" ]]; then
        echo "Usage: Exkeymo.compile-and-use-kcm-layout <input.kcm>" >&2
        return 1
    fi

    # ensure clean
    if [[ -f "$output_apk" ]]; then
        rm "$output_apk"
    fi

    # compile the layout to /tmp/output.apk, quit on non-zero status
    exkeymo.compile-kcm-to-apk "$input_kcm" "$output_apk" || return 1

    # trigger Android's package installer interface
    if [[ -f "$output_apk" ]]; then
        echo "Launching Android package installer..."
        # note: need to set `allow-external-apps = true` in termux.properties
        termux-open "$output_apk"
    fi
}

