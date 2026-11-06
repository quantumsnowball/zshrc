installed tracebox || return


tracebox.trace-scheduling() {
    # auto sudo
    sudo.now
    # scheduling config
    local config="$XDG_CONFIG_HOME/workspace/tracebox/config/scheduling-gaming.pbtx"
    # use $1 if provided, otherwise generate timestamped filename: stutter_YYYYMMDD_HHMMSS.perfetto-trace
    local output_file="${1:-$(date +'%Y%m%d-%H%M%S')_scheduling.perfetto-trace}"
    # run the trace and pipe to file
    sudo tracebox -c "$config" --txt -o - > "$output_file"
}
