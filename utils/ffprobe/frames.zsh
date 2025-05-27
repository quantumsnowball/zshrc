ffprobe.frames.distribution () {
    local WIDTH=60
    local P_char='-'
    local B_char='+'
    local K_char='K'
    local UN_char='?'

    # Print marks
    echo ''
    echo "${BLUE}     predicted frames : '$P_char'${RESET}"
    echo "${CYAN}bi-directional frames : '$B_char'${RESET}"
    echo  "${RED}           key frames : '$K_char'${RESET}"

    # Print ruler
    local ruler=""
    local marks=""
    for ((i=1; i<=WIDTH; i++)); do
        if (( i % 10 == 0 )); then
            ruler+="|"
            marks+=$(printf "%10d" $i)
        else
            ruler+=" "
        fi
    done
    echo ''
    echo "${YELLOW}$marks${RESET}"
    echo "${YELLOW}$ruler${RESET}"


    # ffprobe looping through each frame
    # then print frame type as symbols
    local count=0
    ffprobe -v error \
        -select_streams v:0 \
        -show_entries frame=pict_type \
        -of default=noprint_wrappers=1:nokey=1 \
        "$1" | 
    while read -r type; do
        # predicted frame
        if [[ "$type" == "P" ]]; then
            printf "${BLUE}$P_char${RESET}"
        # bi-directional frame
        elif [[ "$type" == "B" ]]; then
            printf "${CYAN}$B_char${RESET}"
        # intra-frame, key-frame
        elif [[ "$type" == "I" ]]; then
            printf "${RED}$K_char${RESET}"
        else
            printf $UN_char
        fi
        ((count++))
        if (( count % WIDTH == 0 )); then
            echo
        fi
    done

    echo  # newline at end
}

ffprobe.frames.first.info () {
    # shows the first frame info of a video
    ffprobe \
        -v quiet \
        -output_format json \
        -show_frames \
        -hide_banner\
        -read_intervals "%+#1" \
        $1 | jq
}
