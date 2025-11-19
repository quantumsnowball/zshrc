from pathlib import Path

from ffprobe_streams.query import ffprobe
from ffprobe_streams.rich import RichTable


def main(path: Path):
    # query ffprobe
    result = ffprobe(path)
    # present
    RichTable(result).present()
