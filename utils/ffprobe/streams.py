import sys
import subprocess
import json
from datetime import timedelta
from typing import Any
from ansi_colors import *


# types
Json = dict[str, Any]


# constant
NA = 'N/A'
NAN = 'nan'

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
streams: list[Json] = data['streams']


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


def get_index(s: Json, i: int) -> str:
    idx = s.get('index', str(i))
    assert isinstance(idx, int)
    return str(idx)


def get_codec_name(s: Json) -> str:
    try:
        return s['codec_name']
    except KeyError:
        return NA


def get_codec_long_name(s: Json) -> str:
    try:
        return s['codec_long_name']
    except KeyError:
        return NA


def get_codec_type(s: Json) -> str:
    try:
        return s['codec_type']
    except KeyError:
        return NA


def get_duration(s: Json) -> str:
    # try two ways to find duration info
    dur = \
        s.get('duration') or \
        s.get('tags', {}).get('DURATION')
    if dur is None:
        return NAN
    # parse
    dur = str(dur)
    if ':' in dur:
        return dur.split('.')[0]
    else:
        return str(timedelta(seconds=float(dur)))[:-7]


def get_bit_rate(s: Json) -> str | None:
    try:
        bitrate = s['bit_rate']
        return f'{float(bitrate)/1e3} kb/s'
    except KeyError:
        return None


def get_resolution(s: Json) -> str | None:
    try:
        width, height = s['width'], s['height']
        return f'{width} x {height} px'
    except KeyError:
        return None


def get_lang(s: Json) -> str | None:
    try:
        return s['tags']['language']
    except KeyError:
        return None


def print_keyval(key: str, val: str) -> None:
    print(f'{key}: {val}')


def video_title(idx: str, kind: str, duration: str) -> None:
    print_keyval(RichText(f'Stream {idx}').green,
                 RichText(f'{kind} [{duration}]').yellow)


def audio_title(idx: str, kind: str, duration: str) -> None:
    print_keyval(RichText(f'Stream {idx}').green,
                 RichText(f'{kind} [{duration}]').magenta)


def other_title(idx: str, kind: str, duration: str) -> None:
    print_keyval(RichText(f'Stream {idx}').green,
                 RichText(f'{kind} [{duration}]').cyan)


def resolution_as_px(width: str, height: str) -> str:
    return f'{width} x {height} px'


def important(key: str, val: str, *, details: str) -> None:
    print_keyval('\t' + RichText(key).blue,
                 f'{RichText(val).red} ({details})')


def content(key: str, val: str | None) -> None:
    if val is not None:
        print_keyval('\t' + RichText(key).blue,
                     val)


def display(i: int, s: dict[str, Any]) -> None:
    # data
    idx = get_index(s, i)
    name = get_codec_name(s)
    long_name = get_codec_long_name(s)
    kind = get_codec_type(s)
    duration = get_duration(s)
    bitrate = get_bit_rate(s)
    resolution = get_resolution(s)
    lang = get_lang(s)
    # display
    if kind == 'video':
        video_title(idx, kind, duration)
    elif kind == 'audio':
        audio_title(idx, kind, duration)
    else:
        other_title(idx, kind, duration)
    important('codec', name, details=long_name)
    content('resolution', resolution)
    content('bitrate', bitrate)
    content('lang', lang)


# display
print('')
print_keyval('\t< ffprobe', f'total {len(streams)} streams >')
print('')
for i, stream in enumerate(streams):
    display(i, stream)
    print('')
