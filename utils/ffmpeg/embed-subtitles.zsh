ffmpeg.embed-subtitles()
{
  local usage="Usage: ffmpeg-embed-subtitles -i/--input INPUT -s/--subtitles SUBTITLES OUTPUT"

  # parse opts
  local input subs output
  while [[ $# -gt 0 ]]; do
    case $1 in
      -i|--input)
        input="$2"
        shift # past argument
        shift # past value
        ;;
      -s|--subtitles)
        subs="$2"
        shift # past argument
        shift # past value
        ;;
      -*|--*)
        echo "Unknown option $1"
        return 1
        ;;
      *)
        # ensure only set output once
        if [[ -n $output ]]; then
          echo 'Error: Only accept one positional argument as output filename'
          echo $usage
          return 1
        fi
        output="$1" # first positional args
        shift # past argument
        ;;
    esac
  done

  # ensure all options and arg exist
  if [[ -z $input || -z $subs || -z $output ]]; then
    echo $usage
    return 1
  fi

  # choose a subtitle format
  local scodec="srt"
  [[ "$output" == *.mp4 ]] && scodec="mov_text"

  # insert subtitles by ffmpeg
  ffmpeg \
    -i $input \
    -i $subs \
    -c copy \
    -c:s "$scodec" \
    -metadata:s:s:0 language=eng \
    $output

}
