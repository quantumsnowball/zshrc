from dataclasses import dataclass


@dataclass
class Entry:
    field: str
    value: str | None

    @property
    def tuple(self) -> tuple[str, str]:
        return self.field, str(self.value)
