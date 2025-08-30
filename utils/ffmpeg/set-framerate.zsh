ffmpeg.set-framerate() {
  # Usage: ffmpeg.set-framerate -i INPUT -r FRAMERATE OUTPUT
  # Example: ffmpeg.set-framerate -i in.mp4 -r 24 out.mp4
  local usage="Usage: ffmpeg.set-framerate -i INPUT -r/--framerate FRAMERATE OUTPUT"

  # parse opts
  local input=""
  local framerate=""
  local output=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -i)
        input="$2"
        shift # past argument
        shift # past value
        ;;
      -r|--framerate)
        framerate="$2"
        shift # past argument
        shift # past value
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

  if [[ -z "$input" || -z "$framerate" || -z "$output" ]]; then
    echo $usage
    return 1
  fi

  ffmpeg -i "$input" -c copy -video_track_timescale "$framerate" "$output"
}
