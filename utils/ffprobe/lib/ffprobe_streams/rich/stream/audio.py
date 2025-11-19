from ffprobe_streams.result.stream.audio import AudioStream
from ffprobe_streams.rich.lib.field import Entry
from ffprobe_streams.rich.stream import Stream


class Audio(Stream[AudioStream]):
    @property
    def sample_rate(self) -> Entry:
        field = f'[blue]sample rate[/blue]'
        value = f'[white]{self._s.sample_rate} hz[/white]'
        return Entry(field, value)
