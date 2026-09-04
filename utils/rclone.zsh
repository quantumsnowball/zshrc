ensure rclone || return


# check
rclone.remote.check() {
    echo ""
    # run in a subshell to avoid printing the background job debug messages
    (
        # start multiple background jobs to connect to each client
        for name in $(rclone listremotes $1); do
            (
                # basic test is to list the files with depth 1 with a 5s timeout
                timeout 10s rclone lsf "$name" --max-depth 1 &>/dev/null
                res=$?
                if [ $res -eq 0 ]; then
                    printf "%-25s ${GREEN}SUCCESS${RESET}\n" "$name"
                elif [ $res -eq 124 ]; then
                    printf "%-25s ${YELLOW}TIMEOUT${RESET}\n" "$name"
                else
                    printf "%-25s ${RED}FAILED${RESET}\n" "$name"
                fi
            ) &
        done
        # wait before all job done and exit
        wait
    )
    echo ""
}
rclone.remote.check-drive() { rclone.remote.check drive }
rclone.remote.check-sftp() { rclone.remote.check sftp }

# list
rclone.remote.list() { rclone listremotes }
rclone.remote.list-sftp() { rclone listremotes --type sftp }
rclone.remote.list-drive() { rclone listremotes --type drive }
