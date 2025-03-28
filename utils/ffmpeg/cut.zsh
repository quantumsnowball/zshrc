ffmpeg.cut()
{
  local usage="Usage: ffmpeg.cut -i/--input INPUT -ss/--start START -t/--end END OUTPUT"

  # parse opts
  local input ss t output
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
      -t|--end)
        t="$2"
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
  if [[ -z $input || -z $ss || -z $t || -z $output ]]; then
    echo $usage
    return 1
  fi

  # insert subtitles by ffmpeg
  ffmpeg \
    -v warning \
    -ss $ss \
    -t $t \
    -i $input \
    -vcodec copy \
    -acodec copy \
    $output && \
  ls -la $output
}

