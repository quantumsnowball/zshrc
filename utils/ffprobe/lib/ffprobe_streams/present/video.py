from ffprobe_streams.lib.ansi_colors import *
from ffprobe_streams.present.common import *
from ffprobe_streams.result.stream.video import VideoStream


def present_resolution(s: VideoStream) -> None:
    field = f'{BLUE}codec{RESET}'
    value = f'{WHITE}{s.resolution}{RESET}'
    print_field_value(field, value)


def present(i: int, s: VideoStream) -> None:
    present_stream_title(i, s)
    present_codec(s)
    present_resolution(s)
