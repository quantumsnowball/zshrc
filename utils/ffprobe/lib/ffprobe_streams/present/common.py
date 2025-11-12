from ffprobe_streams.lib.ansi_colors import *
from ffprobe_streams.result.stream import Stream


def print_field_value(field: str, value: str | None, *, tab: bool = True) -> None:
    print(f'{'\t' if tab else ''}{field}: {value}')


def present_subject(nb_streams: int | None) -> None:
    if nb_streams is None or nb_streams <= 0:
        print(f"\n\t< ffprobe: no stream found >\n",)
    print(f"\n\t< ffprobe: total {nb_streams} stream(s) >\n",)


def present_format_title() -> None:
    field = f'{GREEN}Format{RESET}'
    value = ''
    print_field_value(field, value, tab=False)


def present_stream_title(i: int, s: Stream) -> None:
    field = f'{GREEN}Stream {i}{RESET}'
    color = YELLOW if s.codec_type == 'video' else MAGENTA
    value = f'{color}{s.codec_type} [{s.duration_hms}]{RESET}'
    print_field_value(field, value, tab=False)


def present_codec(s: Stream) -> None:
    field = f'{BLUE}codec{RESET}'
    value = f'{RED}{s.codec_name}{RESET}'
    detail = f'{WHITE}{s.codec_long_name}{RESET}'
    print_field_value(field, f'{value} ({detail})')


def present_bit_rate(s: Stream) -> None:
    field = f'{BLUE}bitrate{RESET}'
    v = f'{float(br)/1000:.3f} kb/s' if (br := s.bit_rate) else None
    value = f'{WHITE}{v}{RESET}'
    print_field_value(field, value)


def present_language(s: Stream) -> None:
    field = f'{BLUE}language{RESET}'
    value = f'{WHITE}{v}{RESET}' if (v := s.language) else None
    print_field_value(field, value)
