import sys
import subprocess
import json
from datetime import timedelta
from typing import Any
from ansi_colors import GREEN, BLUE, RESET


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
    def green(self) -> str:
        return f'{GREEN}{self.text}{RESET}'

    @property
    def blue(self) -> str:
        return f'{BLUE}{self.text}{RESET}'


def kv(key: str, val: str) -> str:
    return f'{key}: {val}'


def display(s: dict[str, Any]) -> None:
    idx = s['index']
    name = s['codec_name']
    long_name = s['codec_long_name']
    kind = s['codec_type']
    duration = str(timedelta(seconds=float(s['duration'])))[:-7]
    print(kv(Txt(f'Stream {idx}').green, Txt(f'{kind} [{duration}]').blue))
    print(f'\tcodec: {name} ({long_name})')
    if kind == 'video':
        print(f"\tbitrate: {float(s['bit_rate'])/1e3} kb/s")
        print(f"\tresolution: {s['width']} x {s['height']} px")
    elif kind == 'audio':
        print(f"\tbitrate: {float(s['bit_rate'])/1e3} kb/s (lang: {s['tags']['language']})")
        print(f"\tlang: {s['tags']['language']}")
    else:
        print(f"\t")


# display
for s in streams:
    display(s)


class C:
    blue = 'abc'
