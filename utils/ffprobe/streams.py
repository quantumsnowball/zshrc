import sys
import subprocess
import json


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
streams: list[dict[str, str]] = data['streams']

# display streams


def display(s: dict[str, str]) -> None:
    print(s['codec_name'])
    print(s['codec_type'])


for s in streams:
    display(s)
