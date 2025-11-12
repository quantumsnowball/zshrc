from ffprobe_streams.present.audio import present_audio
from ffprobe_streams.present.title import present_stream_title, present_subject
from ffprobe_streams.present.video import present_video
from ffprobe_streams.result import Result
from ffprobe_streams.result.stream.audio import AudioStream
from ffprobe_streams.result.stream.video import VideoStream


def present(r: Result) -> None:
    # subject line
    present_subject(r.nb_streams)
    # present streams
    for i, s in enumerate(r.streams):
        present_stream_title(i, s)
        if isinstance(s, VideoStream):
            present_video(s)
        elif isinstance(s, AudioStream):
            present_audio(s)
