ffprobe.size-info () {
    # Print header
    printf '%-10s %-10s %-18s %-18s %-30s\n' "Size" "Duration" "Rate" "Bitrate" "Name"

    # Default: all common video files in current directory
    local files=("$@")
    if (( $#files == 0 )); then
        # Expand globs safely
        setopt nullglob
        files=(*.mp4(N) *.mkv(N) *.avi(N) *.mov(N) *.webm(N) *.flv(N) *.wmv(N))
        setopt nonomatch  # restore default
        (( $#files == 0 )) && { print "No video files found in current directory." >&2; return 1; }
    fi

    # Process each file
    for file in "${files[@]}"; do
        [[ ! -f "$file" ]] && { print "File not found: $file" >&2; continue; }

        # Get file size in MB (rounded to 1 decimal)
        local size_bytes=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null)
        local size_mb_float=$(awk "BEGIN {printf \"%.1f\", $size_bytes / 1000 / 1000}")
        local size_display="${size_mb_float} MB"

        # Get duration in seconds
        local duration_sec=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file" 2>/dev/null)
        [[ -z "$duration_sec" || "$duration_sec" == "N/A" ]] && duration_sec=0

        # Format duration: HH:MM:SS or H:MM:SS
        local hours=$((duration_sec / 3600))
        local mins=$(((duration_sec % 3600) / 60))
        local secs=$((duration_sec % 60))
        local duration_fmt=$(printf '%02d:%02d:%02d' $hours $mins $secs)
        [[ $hours -eq 0 ]] && duration_fmt=${duration_fmt#0:}

        # Get bitrate (in kbps → display in Kbps with 2 decimals)
        local bitrate_kbps=$(ffprobe -v error -show_entries format=bit_rate -of default=noprint_wrappers=1:nokey=1 "$file" 2>/dev/null)
        [[ -z "$bitrate_kbps" || "$bitrate_kbps" == "N/A" ]] && bitrate_kbps=0
        local bitrate_float=$(awk "BEGIN {printf \"%.2f\", $bitrate_kbps / 1000}")
        local bitrate_display="${bitrate_float} Kbps"

        # Calculate rate: MB per minute (rounded to 2 decimals)
        local rate_mb_min=0
        if (( duration_sec > 0 )); then
            rate_mb_min=$(awk "BEGIN {printf \"%.2f\", ($size_mb_float * 60.0) / $duration_sec}")
        fi
        local rate_display="${rate_mb_min} MB/min"

        # Basename
        local basename=${file:t}

        # Print row
        printf '%-10s %-10s %-18s %-18s %-30s\n' \
            "$size_display" "$duration_fmt" "$rate_display" "$bitrate_display" "$basename"
    done
}
