from ffprobe_streams.present.audio import present_audio
from ffprobe_streams.present.video import present_video
from ffprobe_streams.result import Result
from ffprobe_streams.result.stream.audio import AudioStream
from ffprobe_streams.result.stream.video import VideoStream


def present(r: Result) -> None:
    # subject line
    print(f"\n\t< ffprobe: total {r.nb_streams} stream(s) >\n",)
    # present streams
    for s in r.streams:
        if isinstance(s, VideoStream):
            present_video(s)
        elif isinstance(s, AudioStream):
            present_audio(s)
