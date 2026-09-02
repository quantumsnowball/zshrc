from rich import box
from rich.console import Console
from rich.table import Table

from ffprobe_streams.present.format import Format
from ffprobe_streams.present.general import General
from ffprobe_streams.present.stream.audio import Audio
from ffprobe_streams.present.stream.subtitle import Subtitle
from ffprobe_streams.present.stream.video import Video
from ffprobe_streams.result import Result
from ffprobe_streams.result.stream.audio import AudioStream
from ffprobe_streams.result.stream.subtitle import SubtitleStream
from ffprobe_streams.result.stream.video import VideoStream


class RichTable:
    def __init__(self, r: Result) -> None:
        self._r = r
        self._t = Table(box=box.HORIZONTALS)

    def present(self) -> None:
        # caption
        g = General(self._r)
        self._t.title = g.title

        # format
        f = Format(self._r)
        self._t.add_column(f.title.field)
        self._t.add_column(f.title.value)
        self._t.add_row(*f.size.tuple)
        self._t.add_row(*f.name.tuple)
        self._t.add_row(*f.bit_rate.tuple)

        # present streams
        def video_layout(i: int, stream: VideoStream) -> None:
            s = Video(stream)
            self._t.add_section()
            self._t.add_row(*s.heading(i).tuple)
            self._t.add_section()
            self._t.add_row(*s.codec.tuple)
            self._t.add_row(*s.resolution.tuple)
            self._t.add_row(*s.sample_aspect_ratio.tuple)
            self._t.add_row(*s.display_aspect_ratio.tuple)
            self._t.add_row(*s.time_base.tuple)
            self._t.add_row(*s.r_frame_rate.tuple)
            self._t.add_row(*s.avg_frame_rate.tuple)
            self._t.add_row(*s.nb_frames.tuple)
            self._t.add_row(*s.bit_rate.tuple)
            self._t.add_row(*s.language.tuple)

        def audio_layout(i: int, stream: AudioStream) -> None:
            s = Audio(stream)
            self._t.add_section()
            self._t.add_row(*s.heading(i).tuple)
            self._t.add_section()
            self._t.add_row(*s.codec.tuple)
            self._t.add_row(*s.title.tuple)
            self._t.add_row(*s.bit_rate.tuple)
            self._t.add_row(*s.sample_rate.tuple)
            self._t.add_row(*s.language.tuple)

        def subtitle_layout(i: int, stream: SubtitleStream) -> None:
            s = Subtitle(stream)
            self._t.add_section()
            self._t.add_row(*s.heading(i).tuple)
            self._t.add_section()
            self._t.add_row(*s.codec.tuple)
            self._t.add_row(*s.title.tuple)
            self._t.add_row(*s.language.tuple)

        # present streams
        for i, stream in enumerate(self._r.streams):
            # video stream
            if isinstance(stream, VideoStream):
                video_layout(i, stream)
            # audio stream
            elif isinstance(stream, AudioStream):
                audio_layout(i, stream)
            # subtitle stream
            elif isinstance(stream, SubtitleStream):
                subtitle_layout(i, stream)
        # print
        console = Console()
        console.print(self._t)
