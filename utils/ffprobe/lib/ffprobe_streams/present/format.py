from ffprobe_streams.present.common import present_format_title
from ffprobe_streams.result.format import Format


def present(f: Format) -> None:
    present_format_title()
