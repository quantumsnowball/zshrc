from pathlib import Path

from ffprobe_streams.present import RichTable
from ffprobe_streams.query import ffprobe


def main(path: Path):
    # query ffprobe
    result = ffprobe(path)
    # present
    RichTable(result).present()
