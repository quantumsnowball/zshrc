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
