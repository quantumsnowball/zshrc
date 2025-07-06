ffmpeg.loop()
{
  local usage="Usage: ffmpeg.cut -rr REPEAT --reverse -ss/--start START -to/--end END -i/--input INPUT OUTPUT"

  # parse opts
  local input ss to output
  local rr=1
  local reverse=0
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
      --reverse)
        reverse=1
        shift # past argument
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
  ffmpeg -v warning -i $input -ss $ss -to $to -vcodec libx264 -acodec aac "$tempdir/fwd.vf0.hf0.mp4"
  echo 'part 1 done'
  # hflip
  ffmpeg -v warning -i "$tempdir/fwd.vf0.hf0.mp4" -vf hflip "$tempdir/fwd.vf0.hf1.mp4"
  echo 'part 2 done'
  # vflip
  ffmpeg -v warning -i "$tempdir/fwd.vf0.hf0.mp4" -vf vflip "$tempdir/fwd.vf1.hf0.mp4"
  echo 'part 3 done'
  # vflip + hflip
  ffmpeg -v warning -i "$tempdir/fwd.vf0.hf0.mp4" -vf vflip,hflip "$tempdir/fwd.vf1.hf1.mp4"
  echo 'part 4 done'

  # reverse
  if (( reverse == 1 )); then
    ffmpeg -v warning -i "$tempdir/fwd.vf0.hf0.mp4" -vf reverse -af areverse "$tempdir/rev.vf0.hf0.mp4"
    echo 'part 5 done'
    ffmpeg -v warning -i "$tempdir/fwd.vf0.hf1.mp4" -vf reverse -af areverse "$tempdir/rev.vf0.hf1.mp4"
    echo 'part 6 done'
    ffmpeg -v warning -i "$tempdir/fwd.vf1.hf0.mp4" -vf reverse -af areverse "$tempdir/rev.vf1.hf0.mp4"
    echo 'part 7 done'
    ffmpeg -v warning -i "$tempdir/fwd.vf1.hf1.mp4" -vf reverse -af areverse "$tempdir/rev.vf1.hf1.mp4"
    echo 'part 8 done'
  fi

  # concat all parts as output file
  for ((i=1; i<=rr; i++)); do
    echo "file fwd.vf0.hf0.mp4" >> "$tempdir/list.txt"
    [ $reverse -eq 1 ] && echo "file rev.vf0.hf0.mp4" >> "$tempdir/list.txt"
    echo "file fwd.vf0.hf1.mp4" >> "$tempdir/list.txt"
    [ $reverse -eq 1 ] && echo "file rev.vf0.hf1.mp4" >> "$tempdir/list.txt"
    echo "file fwd.vf1.hf0.mp4" >> "$tempdir/list.txt"
    [ $reverse -eq 1 ] && echo "file rev.vf1.hf0.mp4" >> "$tempdir/list.txt"
    echo "file fwd.vf1.hf1.mp4" >> "$tempdir/list.txt"
    [ $reverse -eq 1 ] && echo "file rev.vf1.hf1.mp4" >> "$tempdir/list.txt"
  done
  ffmpeg -v warning -f concat -safe 0 -i "$tempdir/list.txt" -c copy $output
  echo 'final part done'

  # delete tree tempdir
  rm -rf $tempdir
}
