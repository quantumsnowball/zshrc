import json
import subprocess
from pathlib import Path
from typing import Any

from ffprobe_streams.result import Result


def ffprobe(path: Path) -> Result:
    # cmd
    cmd = [
        "ffprobe",
        "-v", "quiet",
        "-print_format", "json",
        "-show_streams",
        "-show_format",
        path,
    ]
    # run ffprobe as process
    result = subprocess.run(cmd, capture_output=True, text=True, check=True)
    # parse json result
    data: dict[str, Any] = json.loads(result.stdout)
    # return result
    return Result(data)
