from ffprobe_streams.result.stream import Stream


class AudioStream(Stream):
    @property
    def sample_rate(self) -> str | None:
        return self._d.get('sample_rate')
