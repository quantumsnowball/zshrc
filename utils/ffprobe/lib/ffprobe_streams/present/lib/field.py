class Entry:
    def __init__(
        self,
        field: str,
        value: str | None,
    ) -> None:
        self._field = field
        self._value = value

    @property
    def field(self) -> str:
        return self._field

    @property
    def value(self) -> str:
        return self._value or ''

    @property
    def tuple(self) -> tuple[str, str]:
        return self.field, str(self.value)
