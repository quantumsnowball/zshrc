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

# use ffprobe
try:
    stdout = subprocess.check_output(cmd)
except subprocess.CalledProcessError as e:
    print(f'{RED}{e.__class__.__name__}: ffprobe does not show valid result for `{file}`{RESET}')
    print(usage)
    sys.exit(1)

# parse output
data = json.loads(stdout.decode())
streams: list[dict[str, Any]] = data['streams']


# display streams
class RichText:
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

    @property
    def red(self) -> str:
        return f'{RED}{self.text}{RESET}'


def print_keyval(key: str, val: str) -> None:
    print(f'{key}: {val}')


def dur_as_hms(dursec: str) -> str:
    return str(timedelta(seconds=float(dursec)))[:-7]


def video_title(idx: str, kind: str, dursec: str) -> None:
    print_keyval(RichText(f'Stream {idx}').green,
                 RichText(f'{kind} [{dur_as_hms(dursec)}]').yellow)


def audio_title(idx: str, kind: str, dursec: str) -> None:
    print_keyval(RichText(f'Stream {idx}').green,
                 RichText(f'{kind} [{dur_as_hms(dursec)}]').magenta)


def resolution_as_px(width: str, height: str) -> str:
    return f'{width} x {height} px'


def bitrate_as_kbps(bitrate: str) -> str:
    return f'{float(bitrate)/1e3} kb/s'


def important(key: str, val: str, *, details: str) -> None:
    print_keyval('\t' + RichText(key).blue,
                 f'{RichText(val).red} ({details})')


def content(key: str, val: str) -> None:
    print_keyval('\t' + RichText(key).blue,
                 val)


def display(s: dict[str, Any]) -> None:
    # data
    idx = s['index']
    name = s['codec_name']
    long_name = s['codec_long_name']
    kind = s['codec_type']
    dursec = s['duration']
    bitrate = s['bit_rate']
    # display
    if kind == 'video':
        width, height = s['width'], s['height']
        video_title(idx, kind, dursec)
        important('codec', name, details=long_name)
        content('resolution', resolution_as_px(width, height))
        content('bitrate', bitrate_as_kbps(bitrate))
    elif kind == 'audio':
        lang = s['tags']['language']
        audio_title(idx, kind, dursec)
        important('codec', name, details=long_name)
        content('lang', lang)
        content('bitrate', bitrate_as_kbps(bitrate))
    else:
        content('key', 'value')


# display
print('')
print_keyval('\t< ffprobe', f'total {len(streams)} streams >')
print('')
for stream in streams:
    display(stream)
    print('')
