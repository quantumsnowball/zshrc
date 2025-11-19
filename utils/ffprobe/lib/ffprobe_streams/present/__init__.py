from ffprobe_streams.result import Result
from ffprobe_streams.result.stream.audio import AudioStream
from ffprobe_streams.result.stream.video import VideoStream
from ffprobe_streams.present.format import Format
from ffprobe_streams.present.general import General
from ffprobe_streams.present.stream.audio import Audio
from ffprobe_streams.present.stream.video import Video
from rich.console import Console
from rich.table import Table


class RichTable:
    def __init__(self, r: Result) -> None:
        self._r = r
        self._t = Table()

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
        for i, s in enumerate(self._r.streams):
            # video stream
            if isinstance(s, VideoStream):
                v = Video(s)
                self._t.add_section()
                self._t.add_row(*v.title(i).tuple)
                self._t.add_section()
                self._t.add_row(*v.codec.tuple)
                self._t.add_row(*v.resolution.tuple)
                self._t.add_row(*v.sample_aspect_ratio.tuple)
                self._t.add_row(*v.display_aspect_ratio.tuple)
                self._t.add_row(*v.r_frame_rate.tuple)
                self._t.add_row(*v.avg_frame_rate.tuple)
                self._t.add_row(*v.nb_frames.tuple)
                self._t.add_row(*v.bit_rate.tuple)
                self._t.add_row(*v.language.tuple)
            # audio stream
            elif isinstance(s, AudioStream):
                a = Audio(s)
                self._t.add_section()
                self._t.add_row(*a.title(i).tuple)
                self._t.add_section()
                self._t.add_row(*a.codec.tuple)
                self._t.add_row(*a.bit_rate.tuple)
                self._t.add_row(*a.sample_rate.tuple)
                self._t.add_row(*a.language.tuple)

        # print
        console = Console()
        console.print(self._t)
