import sys
import subprocess
import json
from datetime import timedelta
from typing import Any
from ansi_colors import *


# help
usage = 'Usage: ffprobe-streams FILE'


# args
args = sys.argv[1:]


# validate inputs
if len(args) > 1:
    print(usage)
    sys.exit(1)

# ffprobe
file = args[0]
cmd = ('ffprobe',
       '-v', 'quiet',
       '-output_format', 'json',
       '-show_streams',
       '-hide_banner',
       file,)

# parse output
stdout = subprocess.check_output(cmd)
data = json.loads(stdout.decode())
streams: list[dict[str, Any]] = data['streams']


# display streams
class Txt:
    def __init__(self, text: str) -> None:
        self.text = text

    def __str__(self) -> str:
        return self.text

    @property
    def yellow(self) -> str:
        return f'{YELLOW}{self.text}{RESET}'

    @property
    def green(self) -> str:
        return f'{GREEN}{self.text}{RESET}'

    @property
    def cyan(self) -> str:
        return f'{CYAN}{self.text}{RESET}'

    @property
    def blue(self) -> str:
        return f'{BLUE}{self.text}{RESET}'

    @property
    def magenta(self) -> str:
        return f'{MAGENTA}{self.text}{RESET}'


def kv(key: str, val: str) -> None:
    print(f'{key}: {val}')


def durhms(dursec: str) -> str:
    return str(timedelta(seconds=float(dursec)))[:-7]


def video_title(idx: str, kind: str, dursec: str) -> None:
    kv(Txt(f'Stream {idx}').green,
       Txt(f'{kind} [{durhms(dursec)}]').yellow)


def audio_title(idx: str, kind: str, dursec: str) -> None:
    kv(Txt(f'Stream {idx}').green,
       Txt(f'{kind} [{durhms(dursec)}]').magenta)


def content(key: str, val: str) -> None:
    kv('\t' + Txt(key).blue,
       val)


def display(s: dict[str, Any]) -> None:
    # data
    idx = s['index']
    name = s['codec_name']
    long_name = s['codec_long_name']
    kind = s['codec_type']
    dursec = s['duration']
    # display
    if kind == 'video':
        video_title(idx, kind, dursec)
        content('codec', f'{name} ({long_name})')
        content('resolution', f"{s['width']} x {s['height']} px")
        content('bitrate', f"{float(s['bit_rate'])/1e3} kb/s")
    elif kind == 'audio':
        audio_title(idx, kind, dursec)
        content('codec', f'{name} ({long_name})')
        content('bitrate', f"{float(s['bit_rate'])/1e3} kb/s")
        content('lang', f"{s['tags']['language']}")
    else:
        content("", '')


# display
print('')
for s in streams:
    display(s)
    print('')
