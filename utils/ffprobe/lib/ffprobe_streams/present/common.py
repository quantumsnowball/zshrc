from ffprobe_streams.lib.ansi_colors import *
from ffprobe_streams.result.stream import Stream


def present_subject(nb_streams: int) -> None:
    print(f"\n\t< ffprobe: total {nb_streams} stream(s) >\n",)


def present_stream_title(i: int, s: Stream) -> None:
    field = f'{GREEN}Stream {i}{RESET}'
    color = YELLOW if s.codec_type == 'video' else MAGENTA
    content = f'{color}{s.codec_type} [{s.duration_hms}]{RESET}'
    print(f'{field}: {content}')


def present_codec(s: Stream) -> None:
    field = f'{BLUE}codec{RESET}'
    content = f'{RED}{s.codec_name}{RESET}'
    detail = f'{WHITE}{s.codec_long_name}{RESET}'
    print(f'\t{field}: {content} ({detail})')
