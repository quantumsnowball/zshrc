from typing import Any


class Result:
    def __init__(self, data: dict[str, Any]) -> None:
        self._d = data
        # from pprint import pprint
        # pprint(self._d)

    @property
    def streams(self) -> dict[str, Any]:
        return self._d['streams']

    @property
    def format(self) -> dict[str, Any]:
        return self._d['format']

    @property
    def nb_streams(self) -> int:
        return int(self.format['nb_streams'])
