from ffprobe_streams.present.common import *
from ffprobe_streams.result.stream.audio import AudioStream


def present_sample_rate(s: AudioStream) -> None:
    field = f'{BLUE}sample rate{RESET}'
    value = f'{WHITE}{s.sample_rate} hz{RESET}'
    print_field_value(field, value)


def present(i: int, s: AudioStream) -> None:
    present_stream_title(i, s)
    present_codec(s)
    present_bit_rate(s)
    present_sample_rate(s)
    present_language(s)
