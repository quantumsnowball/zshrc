from ffprobe_streams.lib.ansi_colors import GREEN, MAGENTA, RESET, YELLOW
from ffprobe_streams.present.audio import present_audio
from ffprobe_streams.present.video import present_video
from ffprobe_streams.result import Result
from ffprobe_streams.result.stream import Stream
from ffprobe_streams.result.stream.audio import AudioStream
from ffprobe_streams.result.stream.video import VideoStream


def present_stream_title(i: int, s: Stream) -> None:
    field = f'{GREEN}Stream {i}{RESET}'
    color = YELLOW if s.codec_type == 'video' else MAGENTA
    content = f'{color}{s.codec_type} []{RESET}'
    print(f'{field}: {content}')


def present(r: Result) -> None:
    # subject line
    print(f"\n\t< ffprobe: total {r.nb_streams} stream(s) >\n",)
    # present streams
    for i, s in enumerate(r.streams):
        present_stream_title(i, s)
        if isinstance(s, VideoStream):
            present_video(s)
        elif isinstance(s, AudioStream):
            present_audio(s)
