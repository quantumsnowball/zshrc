from ffprobe_streams.lib.ansi_colors import *
from ffprobe_streams.present.common import *
from ffprobe_streams.result.stream.video import VideoStream


def present_resolution(s: VideoStream) -> None:
    field = f'{BLUE}codec{RESET}'
    value = f'{WHITE}{s.resolution}{RESET}'
    print_field_value(field, value)


def present_sample_aspect_ratio(s: VideoStream) -> None:
    field = f'{BLUE}sample aspect ratio{RESET}'
    value = f'{WHITE}{s.sample_aspect_ratio}{RESET}'
    print_field_value(field, value)


def present_display_aspect_ratio(s: VideoStream) -> None:
    field = f'{BLUE}display aspect ratio{RESET}'
    value = f'{WHITE}{s.display_aspect_ratio}{RESET}'
    print_field_value(field, value)


def present_r_frame_rate(s: VideoStream) -> None:
    field = f'{BLUE}frame rate{RESET}'
    value = f'{WHITE}{s.r_frame_rate}{RESET}'
    print_field_value(field, value)


def present(i: int, s: VideoStream) -> None:
    present_stream_title(i, s)
    present_codec(s)
    present_resolution(s)
    present_sample_aspect_ratio(s)
    present_display_aspect_ratio(s)
    present_r_frame_rate(s)
