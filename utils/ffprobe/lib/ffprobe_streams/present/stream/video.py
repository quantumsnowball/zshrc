from ffprobe_streams.result.stream.video import VideoStream
from ffprobe_streams.present.lib.field import Entry
from ffprobe_streams.present.stream import Stream


class Video(Stream[VideoStream]):
    @property
    def resolution(self) -> Entry:
        field = f'[blue]resolution[/blue]'
        value = f'[white]{self._s.resolution}[/white]'
        return Entry(field, value)

    @property
    def sample_aspect_ratio(self) -> Entry:
        field = f'[blue]sample aspect ratio[/blue]'
        value = f'[white]{self._s.sample_aspect_ratio}[/white]'
        return Entry(field, value)

    @property
    def display_aspect_ratio(self) -> Entry:
        field = f'[blue]display aspect ratio[/blue]'
        value = f'[white]{self._s.display_aspect_ratio}[/white]'
        return Entry(field, value)

    @property
    def time_base(self) -> Entry:
        field = f'[blue]time base[/blue]'
        value = f'[white]{self._s.time_base}[/white]'
        return Entry(field, value)

    @property
    def r_frame_rate(self) -> Entry:
        field = f'[blue]frame rate[/blue]'
        value = f'[white]{self._s.r_frame_rate}[/white]'
        return Entry(field, value)

    @property
    def avg_frame_rate(self) -> Entry:
        field = f'[blue]average frame rate[/blue]'
        value = f'[white]{eval(afr):.2f} ({afr})[/white]' if (afr := self._s.avg_frame_rate) else None
        return Entry(field, value)

    @property
    def nb_frames(self) -> Entry:
        field = f'[blue]frame count[/blue]'
        value = f'[white]{self._s.nb_frames}[/white]' if self._s.nb_frames else None
        return Entry(field, value)
