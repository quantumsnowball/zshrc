from ffprobe_streams.result.stream import Stream


class VideoStream(Stream):
    @property
    def width(self) -> str:
        return self._d['width']

    @property
    def height(self) -> str:
        return self._d['height']

    @property
    def resolution(self) -> str:
        return f'{self.width} x {self.height} px'

    @property
    def sample_aspect_ratio(self) -> str:
        return self._d['sample_aspect_ratio']

    @property
    def display_aspect_ratio(self) -> str:
        return self._d['display_aspect_ratio']

    @property
    def r_frame_rate(self) -> str:
        return self._d['r_frame_rate']

    @property
    def avg_frame_rate(self) -> str:
        return self._d['r_frame_rate']
