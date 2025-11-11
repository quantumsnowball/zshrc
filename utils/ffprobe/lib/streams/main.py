import sys
from pathlib import Path

from . import streams


def main():
    # get args
    args = sys.argv
    # check args
    if len(args) != 2:
        print('Usage: ffmpeg.streams <path>')
        return
    # pass args
    path = Path(args[1])
    streams(path)


if __name__ == "__main__":
    main()
