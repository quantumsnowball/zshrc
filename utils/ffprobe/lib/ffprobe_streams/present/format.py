from ffprobe_streams.lib.ansi_colors import *
from ffprobe_streams.present.common import *
from ffprobe_streams.result.format import Format


def present_name(f: Format) -> None:
    field = f'{BLUE}name{RESET}'
    value = f'{RED}{f.format_name}{RESET}'
    detail = f'{WHITE}{f.format_long_name}{RESET}'
    print_field_value(field, f'{value} ({detail})')


def present(f: Format) -> None:
    present_format_title()
    present_name(f)
