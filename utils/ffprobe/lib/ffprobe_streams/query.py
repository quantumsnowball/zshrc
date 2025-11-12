import json
import subprocess
from collections import defaultdict
from functools import partial
from pathlib import Path
from typing import Any, DefaultDict

from ffprobe_streams.result import Result


def ffprobe(path: Path) -> Result:
    # cmd
    cmd = [
        "ffprobe",
        "-v", "quiet",
        "-print_format", "json",
        "-show_streams",
        "-show_format",
        str(path),
    ]
    # run ffprobe as process
    result = subprocess.run(cmd, capture_output=True, text=True, check=True)
    # parse json result
    data: DefaultDict[str, Any] = json.loads(result.stdout, object_hook=partial(defaultdict, lambda: None))
    # return result
    return Result(data)
