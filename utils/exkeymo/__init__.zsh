ensure node || return
ensure apktool || return


exkeymo.use-kcm-layout() {
    local layout_kcm_file="$1"
    local tag="${2:-$(basename "$layout_kcm_file" .kcm)}"
    local work_dir="$TMPDIR/.exkeymo"
    local original_template_file="$XDG_CONFIG_HOME/workspace/exkeymo/template.apk"
    local renaming_template_dir="$work_dir/renaming-template/"
    local renamed_template_file=$work_dir/exkeymo-template.apk
    local result_apk_file="$work_dir/exkeymo.apk"

    # cleanup
    rm -rf "$work_dir"
    # prepare work_dir
    echo "Working directory at $work_dir"
    mkdir -p "$work_dir"

    # unpack template
    apktool decode "$original_template_file" -o "$renaming_template_dir"
    # TODO: modify the files
    #
    # repack template
    apktool build "$renaming_template_dir" -o "$renamed_template_file"

    # compile the layout to /tmp/output.apk, quit on non-zero status
    node "$XDG_CONFIG_HOME/zshrc/utils/exkeymo/compiler/main.js" \
        "$layout_kcm_file" "$renamed_template_file" "$result_apk_file" || return 1

    # trigger Android's package installer interface
    # note: need to set `allow-external-apps = true` in termux.properties
    echo "Launching Android package installer..."
    termux-open "$result_apk_file"
}

