ensure /opt/google/chrome/google-chrome-kwallet || return


alias google-chrome-kwallet=/opt/google/chrome/google-chrome-kwallet


google-chrome-kwallet.ensure-all-pwa-starts-with-kwallet() {
    local app_dir="$HOME/.local/share/applications"

    # locate all chrome related desktop files
    local files=(${app_dir}/chrome-*.desktop(N))
    if (( ${#files} == 0 )); then
        echo -e "${YELLOW}No matching chrome-*.desktop files found in $app_dir.${RESET}"
        return 0
    fi

    # search and replace google-chrome with the custom google--chrome-kwallet
    local file old_line new_line answer
    local sed_pattern='s|^Exec=/opt/google/chrome/google-chrome |Exec=/opt/google/chrome/google-chrome-kwallet |'
    for file in "${files[@]}"; do
        # ensure these is a line starting with 'Exec=/opt/google/chrome/google-chrome '
        if grep -q '^Exec=/opt/google/chrome/google-chrome ' "$file"; then
            # generate a preview
            old_line=$(grep '^Exec=/opt/google/chrome/google-chrome ' "$file" | head -n 1)
            new_line=$(echo "$old_line" | sed "$sed_pattern")
            # prompt the user for confirmation
            echo "--------------------------------------------------"
            echo -e "File:   ${CYAN}${file/#$HOME/~}${RESET}"
            echo -e "Before: ${RED}${old_line}${RESET}"
            echo -e "After:  ${GREEN}${new_line}${RESET}"
            echo -n -e "Apply this change? [y/N]: "
            read -r answer
            if [[ "$answer" =~ ^[Yy]$ ]]; then
                # actually modify the file using the sed pattern
                sed -i "$sed_pattern" "$file"
                echo -e "${GREEN}Done!${RESET}"
            fi
        fi
    done
    echo "--------------------------------------------------"
    echo -e "${GREEN}All done!${RESET}"
}
