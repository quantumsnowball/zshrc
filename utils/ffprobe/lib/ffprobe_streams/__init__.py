from pathlib import Path

from ffprobe_streams.presentation import present
from ffprobe_streams.query import ffprobe


def main(path: Path):
    # query ffprobe
    result = ffprobe(path)
    # present
    present(result)
