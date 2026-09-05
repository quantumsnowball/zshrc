[[ -d "$HOME/Projects/exkeymo/" ]] || return


exkeymo.start-local-builder-server() {
    (
        cd "$HOME/Projects/exkeymo/"
        python -m http.server 8080
    )
}

exkeymo.compile-kcm-to-apk() {
    # pass any args into compile.js
    node "$XDG_CONFIG_HOME/zshrc/utils/exkeymo/compile.js" "$@"
}
