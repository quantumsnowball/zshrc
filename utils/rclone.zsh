ensure rclone || return


rclone.check-remotes() {
    for r in $(rclone listremotes); do
        rclone lsf "$r" --max-depth 1 &>/dev/null \
            && printf "%-25s SUCCESS\n" "$r" \
            || printf "%-25s FAILED\n" "$r"
    done
}
