ensure rclone || return


rclone.check-remotes() {
    echo ""
    # run in a subshell to avoid printing the background job debug messages
    (
        # start multiple background jobs to connect to each client
        for name in $(rclone listremotes); do
            ( 
                # basic test is to list the files with depth 1
                rclone lsf "$name" --max-depth 1 &>/dev/null \
                    && printf "%-25s ${GREEN}SUCCESS${RESET}\n" "$name" \
                    || printf "%-25s ${RED}FAILED${RESET}\n" "$name" 
            ) &
        done
        # wait before all job done and exit
        wait
    )
    echo ""
}
