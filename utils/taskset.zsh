installed taskset || return


cpu.use-cores() {
    # guard args
    [[ "$#" -ne 2 ]] && { echo "usage: cpu.use-cpu-cores <cores> <process_name>" >&2; return 1; }

    local cores="$1"
    local proc_name="$2"
    local pids

    # search for pids matching the process string
    pids=$(pgrep -f "$proc_name")

    # guard non empty pid list
    [[ -z "$pids" ]] && { echo "no process found matching: $proc_name" >&2; return 1; }

    # set cpu affinity for each pid found
    for pid in ${=pids}; do
        taskset -cp "$cores" "$pid"
    done
}

cpu.use-p-cores() {
    [[ "$#" -ne 1 ]] && { echo "usage: cpu.use-p-cores <process_name>" >&2; return 1; }
    cpu.use-cores 0-15 "$1"
}
cpu.use-e-cores() {
    [[ "$#" -ne 1 ]] && { echo "usage: cpu.use-e-cores <process_name>" >&2; return 1; }
    cpu.use-cores 16-27 "$1"
}
