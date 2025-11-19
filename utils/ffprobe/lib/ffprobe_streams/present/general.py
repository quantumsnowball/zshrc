from ffprobe_streams.result import Result


class General:
    def __init__(self, r: Result) -> None:
        self._r = r

    @property
    def title(self) -> str:
        nb_streams = self._r.format.nb_streams
        if nb_streams is None or nb_streams <= 0:
            return 'ffprobe: no stream found'
        return f'ffprobe: total {nb_streams} stream(s)'
