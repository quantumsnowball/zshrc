from pathlib import Path

from ffprobe_streams.present import present as present_old
from ffprobe_streams.query import ffprobe
from ffprobe_streams.rich import RichTable


def main(path: Path):
    # query ffprobe
    result = ffprobe(path)
    # present
    present_old(result)
    RichTable(result).present()
