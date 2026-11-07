installed taskset || return


cpu.list-use-cores() {
    # guard args
    [[ "$#" -lt 1 ]] && { echo "usage: cpu.list-use-cores <process_name1> [process_name2 ...]" >&2; return 1; }

    local proc_name
    local pids

    # iterate through all specified process search targets
    for proc_name in "$@"; do
        echo "\n${YELLOW}=== target: $proc_name ===${RESET}"

        # search for pids matching the process string
        pids=$(pgrep -f "$proc_name")

        # guard non empty pid list
        if [[ -z "$pids" ]]; then
            echo "no process found matching: $proc_name" >&2
            continue
        fi

        # display cpu affinity for each pid found
        for pid in ${=pids}; do
            taskset -p "$pid"
        done
    done
    echo ""
}

cpu.use-cores() {
    # guard args
    [[ "$#" -lt 2 ]] && { echo "usage: cpu.use-cores <cores> <process_name1> [process_name2 ...]" >&2; return 1; }

    local cores="$1"
    shift

    local proc_name
    local pids

    # iterate through all specified process search targets
    for proc_name in "$@"; do
        echo "\n${YELLOW}=== target: $proc_name ===${RESET}"

        # search for pids matching the process string
        pids=$(pgrep -f "$proc_name")

        # guard non empty pid list
        if [[ -z "$pids" ]]; then
            echo "no process found matching: $proc_name" >&2
            continue
        fi

        # set cpu affinity for each pid found
        for pid in ${=pids}; do
            taskset -cp "$cores" "$pid"
        done
    done
    echo ""
}

cpu.use-p-cores() {
    [[ "$#" -lt 1 ]] && { echo "usage: cpu.use-p-cores <process_name1> [process_name2 ...]" >&2; return 1; }
    cpu.use-cores 0-15 "$@"
}

cpu.use-e-cores() {
    [[ "$#" -lt 1 ]] && { echo "usage: cpu.use-e-cores <process_name1> [process_name2 ...]" >&2; return 1; }
    cpu.use-cores 16-27 "$@"
}

cpu.use-all-cores() {
    [[ "$#" -lt 1 ]] && { echo "usage: cpu.use-all-cores <process_name1> [process_name2 ...]" >&2; return 1; }
    cpu.use-cores 0-27 "$@"
}
