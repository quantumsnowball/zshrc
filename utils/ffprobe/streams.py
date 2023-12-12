import sys
import subprocess
import json
from typing import Any


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
def display(s: dict[str, Any]) -> None:
    idx = s['index']
    name = s['codec_name']
    long_name = s['codec_long_name']
    kind = s['codec_type']
    print(f'Stream {idx}: {kind}')
    print(f'\t{name} ({long_name})')
    if kind == 'video':
        print(f"\t{s['width']} x {s['height']} px")
    elif kind == 'audio':
        print(f"\t{float(s['bit_rate'])/1e3} kb/s (lang: {s['tags']['language']})")
    else:
        print(f"\t")


for s in streams:
    display(s)
