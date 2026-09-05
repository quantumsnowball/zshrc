[[ -d "$HOME/Projects/exkeymo/" ]] || return


exkeymo.start-local-builder-server() {
    (
        cd "$HOME/Projects/exkeymo/"
        python -m http.server 8080
    )
}
