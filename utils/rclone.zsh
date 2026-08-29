ensure rclone || return


rclone.check-remotes() {
    # run in a subshell to avoid printing the background job debug messages
    (
        # start multiple background jobs to connect to each client
        for r in $(rclone listremotes); do
            ( 
                # basic test is to list the files with depth 1
                rclone lsf "$r" --max-depth 1 &>/dev/null \
                    && printf "%-25s SUCCESS\n" "$r" \
                    || printf "%-25s FAILED\n" "$r" 
            ) &
        done
        wait
    )
}
