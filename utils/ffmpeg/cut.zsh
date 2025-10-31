ffmpeg.cut()
{
  local usage="Usage: ffmpeg.cut -ss/--start START -to/--end END -i/--input INPUT OUTPUT"

  # parse opts
  local input ss to output
  while [[ $# -gt 0 ]]; do
    case $1 in
      -i|--input)
        input="$2"
        shift # past argument
        shift # past value
        ;;
      -ss|--start)
        ss="$2"
        shift # past argument
        shift # past value
        ;;
      -to|--end)
        to="$2"
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
  if [[ -z $input || -z $ss || -z $to || -z $output ]]; then
    echo $usage
    return 1
  fi

  # run ffmpeg to cut the video and ls output file
  # -ss before -i will fast seek to nearest keyframe before, may miss the starting key frame
  # -ss after -i will need to decode whole video up before seekign up to -ss, but guaratee start with keyframe
  ffmpeg \
    -v warning \
    -i $input \
    -ss $ss \
    -to $to \
    -vcodec copy \
    -acodec copy \
    $output && \
  ls -la $output
}

