from ffprobe_streams.present.common import *
from ffprobe_streams.result.stream.audio import AudioStream


def present(i: int, s: AudioStream) -> None:
    present_stream_title(i, s)
    present_codec(s)
