ffmpeg.loop()
{
  local usage="Usage: ffmpeg.cut -rr REPEAT -ss/--start START -to/--end END -i/--input INPUT OUTPUT"

  # parse opts
  local input ss to output
  local rr=1
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
      -rr|--repeat)
        rr="$2"
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
  # spec: [fwd|rev].vf[0|1].hf[0|1].mp4 total 8 files

  # original
  ffmpeg -v warning -ss $ss -to $to -i $input -vcodec copy -acodec copy "$tempdir/fwd.vf0.hf0.mp4"
  echo '1'
  # hflip
  ffmpeg -v warning -i "$tempdir/fwd.vf0.hf0.mp4" -vf hflip "$tempdir/fwd.vf0.hf1.mp4"
  echo '2'
  # vflip
  ffmpeg -v warning -i "$tempdir/fwd.vf0.hf0.mp4" -vf vflip "$tempdir/fwd.vf1.hf0.mp4"
  echo '3'
  # vflip + hflip
  ffmpeg -v warning -i "$tempdir/fwd.vf0.hf0.mp4" -vf vflip,hflip "$tempdir/fwd.vf1.hf1.mp4"
  echo '4'

  # reverse
  ffmpeg -v warning -i "$tempdir/fwd.vf0.hf0.mp4" -vf reverse -af areverse "$tempdir/rev.vf0.hf0.mp4"
  echo '5'
  ffmpeg -v warning -i "$tempdir/fwd.vf0.hf1.mp4" -vf reverse -af areverse "$tempdir/rev.vf0.hf1.mp4"
  echo '6'
  ffmpeg -v warning -i "$tempdir/fwd.vf1.hf0.mp4" -vf reverse -af areverse "$tempdir/rev.vf1.hf0.mp4"
  echo '7'
  ffmpeg -v warning -i "$tempdir/fwd.vf1.hf1.mp4" -vf reverse -af areverse "$tempdir/rev.vf1.hf1.mp4"
  echo '8'

  # concat all parts as output file
  for ((i=1; i<=rr; i++)); do
    echo "file fwd.vf0.hf0.mp4" >> "$tempdir/list.txt"
    echo "file rev.vf0.hf0.mp4" >> "$tempdir/list.txt"
    echo "file fwd.vf0.hf1.mp4" >> "$tempdir/list.txt"
    echo "file rev.vf0.hf1.mp4" >> "$tempdir/list.txt"
    echo "file fwd.vf1.hf0.mp4" >> "$tempdir/list.txt"
    echo "file rev.vf1.hf0.mp4" >> "$tempdir/list.txt"
    echo "file fwd.vf1.hf1.mp4" >> "$tempdir/list.txt"
    echo "file rev.vf1.hf1.mp4" >> "$tempdir/list.txt"
  done
  ffmpeg -v warning -f concat -safe 0 -i "$tempdir/list.txt" -c copy $output
  echo 'done'

  # delete tree tempdir
  rm -rf $tempdir
}
