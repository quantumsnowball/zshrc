from ffprobe_streams.present.format import present as present_format
from ffprobe_streams.present.lib.share import present_subject
from ffprobe_streams.present.stream.audio import present as present_audio
from ffprobe_streams.present.stream.video import present as present_video
from ffprobe_streams.result import Result
from ffprobe_streams.result.stream.audio import AudioStream
from ffprobe_streams.result.stream.video import VideoStream


def present(r: Result) -> None:
    # subject line
    present_subject(r.format.nb_streams)
    # present format
    present_format(r.format)
    # present streams
    for i, s in enumerate(r.streams):
        if isinstance(s, VideoStream):
            present_video(i, s)
        elif isinstance(s, AudioStream):
            present_audio(i, s)
