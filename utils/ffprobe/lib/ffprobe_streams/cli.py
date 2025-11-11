import sys
from pathlib import Path

from ffprobe_streams import main


def cli():
    # get args
    args = sys.argv
    # check args
    if len(args) != 2:
        print('Usage: ffmpeg.streams <path>')
        return
    # pass args
    path = Path(args[1])
    main(path)


if __name__ == "__main__":
    cli()
