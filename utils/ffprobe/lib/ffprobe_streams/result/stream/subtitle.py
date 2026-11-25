from ffprobe_streams.result.stream import Stream


class SubtitleStream(Stream):
    @property
    def title(self) -> str | None:
        if (tags := self._d['tags']) and (result := tags['name']):
            return result
        # else
        return None
