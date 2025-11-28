from ffprobe_streams.result.stream import Stream


class VideoStream(Stream):
    @property
    def width(self) -> str | None:
        return self._d['width']

    @property
    def height(self) -> str | None:
        return self._d['height']

    @property
    def resolution(self) -> str | None:
        return f'{self.width} x {self.height} px'

    @property
    def sample_aspect_ratio(self) -> str | None:
        return self._d['sample_aspect_ratio']

    @property
    def display_aspect_ratio(self) -> str | None:
        return self._d['display_aspect_ratio']

    @property
    def time_base(self) -> str | None:
        return self._d['time_base']

    @property
    def r_frame_rate(self) -> str | None:
        return self._d['r_frame_rate']

    @property
    def avg_frame_rate(self) -> str | None:
        return self._d['r_frame_rate']

    @property
    def nb_frames(self) -> str | None:
        return self._d['nb_frames']
