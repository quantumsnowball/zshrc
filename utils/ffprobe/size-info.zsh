ffprobe.size-info () {
    # Print header (Name last)
    printf '%-10s %-10s %-18s %-18s %-30s\n' "Size" "Duration" "Rate" "Bitrate" "Name"

    # Process each file
    for file in "$@"; do
        [[ ! -f "$file" ]] && { print "File not found: $file" >&2; continue; }

        # Get file size in bytes
        local size_bytes=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null)
        local size_mb_float=$(awk "BEGIN {printf \"%.1f\", $size_bytes / 1000 / 1000}")
        local size_display="${size_mb_float} MB"

        # Get duration in seconds using ffprobe
        local duration_sec=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file" 2>/dev/null)
        [[ -z "$duration_sec" || "$duration_sec" == "N/A" ]] && duration_sec=0

        # Format duration as HH:MM:SS
        local hours=$((duration_sec / 3600))
        local mins=$(((duration_sec % 3600) / 60))
        local secs=$((duration_sec % 60))
        local duration_fmt=$(printf '%0d:%02d:%02d' $hours $mins $secs)
        [[ $hours -eq 0 ]] && duration_fmt=${duration_fmt#0:}

        # Get bitrate in kbps
        local bitrate_kbps=$(ffprobe -v error -show_entries format=bit_rate -of default=noprint_wrappers=1:nokey=1 "$file" 2>/dev/null)
        [[ -z "$bitrate_kbps" || "$bitrate_kbps" == "N/A" ]] && bitrate_kbps=0
        local bitrate_float=$(awk "BEGIN {printf \"%.2f\", $bitrate_kbps / 1000}")
        local bitrate_display="${bitrate_float} Kbps"

        # Calculate rate: MB per minute (rounded to integer)
        local rate_mb_min=0
        if (( duration_sec > 0 )); then
            rate_mb_min=$(awk "BEGIN {printf \"%.2f\", ($size_mb_float * 60.0) / $duration_sec + 0.5}")
        fi
        local rate_display="${rate_mb_min} MB/min"

        # Get basename
        local basename=${file:t}

        # Print aligned row
        printf '%-10s %-10s %-18s %-18s %-30s\n' \
            "$size_display" "$duration_fmt" "$rate_display" "$bitrate_display" "$basename"
    done
}
