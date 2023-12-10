ffmpeg-concat()
{
  # constants
  local usage="Usage: $(basename $0) [-o OUTPUT] [PARTS ...]" 
  local listfile="$(date +%s%N).txt"

  # parse opts
  local oflag output
  while getopts 'o:' OPTION; do
    case "$OPTION" in
      o)
          oflag=true
          output=$OPTARG
          ;;
      ?)
          echo $usage >&2
          return 1
          ;;
    esac
  done
  shift $((OPTIND - 1));

  # checks opts
  if (($# == 0))
  then
      echo $usage
      echo "Error: must supply at least one source file to concat"
      return 1
  fi
  if [ ! $oflag ]
  then
      echo $usage
      echo "Error: must supply the -o output flag"
      return 1
  fi

  # generate list file
  while test $# -gt 0; do
      echo "file '$1'" >> $listfile
      shift
  done

  # concat file by ffmpeg
  ffmpeg -f concat -safe 0 -i $listfile -c copy $output

  # clean up
  rm $listfile
}
