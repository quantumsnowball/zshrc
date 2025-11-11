from pathlib import Path

from ffprobe_streams.query import ffprobe


def main(path: Path):
    # query ffprobe
    r = ffprobe(path)
    # subject line
    print(f"\n\t< ffprobe: total {r.nb_streams} stream(s) >\n",)
