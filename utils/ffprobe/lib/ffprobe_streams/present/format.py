from ffprobe_streams.lib.ansi_colors import *
from ffprobe_streams.present.common import (present_format_title,
                                            print_field_value)
from ffprobe_streams.result.format import Format


def present_name(f: Format) -> None:
    field = f'{BLUE}name{RESET}'
    value = f'{RED}{f.format_name}{RESET}'
    detail = f'{WHITE}{f.format_long_name}{RESET}'
    print_field_value(field, f'{value} ({detail})')


def present_bit_rate(f: Format) -> None:
    field = f'{BLUE}bitrate{RESET}'
    v = f'{float(br)/1e6:.3f} Mb/s' if (br := f.bit_rate) else None
    value = f'{WHITE}{v}{RESET}'
    print_field_value(field, value)


def present(f: Format) -> None:
    present_format_title(f)
    present_name(f)
    present_bit_rate(f)
