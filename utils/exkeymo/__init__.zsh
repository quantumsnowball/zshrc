ensure node || return
ensure apktool || return


exkeymo.install-layout() {
    # help
    local help_text="Usage: $0 <layout>.kcm [<tag>]"
    
    # assert layout file exists and is a kcm file
    local layout_kcm_file="$1"
    [[ ! -f "$layout_kcm_file" ]] && { echo "Error: layout file does not exists"; echo "$help_text"; return 1 } 
    [[ "$layout_kcm_file" != *.kcm ]] && { echo "Error: layout file must be a .kcm file"; echo "$help_text"; return 1 }

    # ensure tag contains only alphabets
    local tag="${2:-$(basename "$layout_kcm_file" .kcm)}"
    [[ ! "$tag" =~ ^[a-zA-Z]+$ ]] && { echo "Error: tag only support alphabets"; echo "$help_text"; return 1; }

    # vars
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
    # update package name / references in AndroidManifest.xml
    echo "updateing AndroidManifest.xml..."
    sed -i "s/exkeymo/exkeymo_${tag}/g" "$renaming_template_dir/AndroidManifest.xml"
    # update app label in strings.xml with an uppercase version of the tag
    echo "updating strings.xml ..."
    sed -i "s/ExKeyMo/ExKeyMo ${tag:u}/g" "$renaming_template_dir/res/values/strings.xml"
    # repack template
    apktool build "$renaming_template_dir" -o "$renamed_template_file"

    # compile the layout to $result_apk_file, quit on non-zero status
    node "$XDG_CONFIG_HOME/zshrc/utils/exkeymo/compiler/main.js" \
        "$layout_kcm_file" "$renamed_template_file" "$result_apk_file" || return 1

    # trigger Android's package installer interface
    # note: need to set `allow-external-apps = true` in termux.properties
    echo "Launching Android package installer..."
    termux-open "$result_apk_file"
}

