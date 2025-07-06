ffmpeg.loop()
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

  # create tempdir
  local tempdir=".ffmpeg.loop"
  mkdir -p $tempdir

  # extract source segment
  # spec: vf[0|1].hf[0|1].[fwd|bwd].mp4 total 8 files
  # original
  ffmpeg -v warning -ss $ss -to $to -i $input -vcodec copy -acodec copy "$tempdir/vf0.hf0.fwd.mp4"
  # hflip
  ffmpeg -v warning -i "$tempdir/vf0.hf0.fwd.mp4" -vf hflip "$tempdir/vf0.hf1.fwd.mp4"
  # vflip
  ffmpeg -v warning -i "$tempdir/vf0.hf0.fwd.mp4" -vf vflip "$tempdir/vf1.hf0.fwd.mp4"
  # vflip + hflip
  ffmpeg -v warning -i "$tempdir/vf0.hf0.fwd.mp4" -vf vflip,hflip "$tempdir/vf1.hf1.fwd.mp4"

  # delete tree tempdir
  #
}
