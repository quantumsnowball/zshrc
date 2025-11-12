from ffprobe_streams.lib.ansi_colors import GREEN, MAGENTA, RESET, YELLOW
from ffprobe_streams.result.stream import Stream


def present_subject(nb_streams: int) -> None:
    print(f"\n\t< ffprobe: total {nb_streams} stream(s) >\n",)


def present_stream_title(i: int, s: Stream) -> None:
    field = f'{GREEN}Stream {i}{RESET}'
    color = YELLOW if s.codec_type == 'video' else MAGENTA
    content = f'{color}{s.codec_type} [{s.duration}]{RESET}'
    print(f'{field}: {content}')
