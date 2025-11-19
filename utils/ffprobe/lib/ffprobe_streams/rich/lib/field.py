from dataclasses import dataclass


@dataclass
class Entry:
    field: str
    value: str

    @property
    def tuple(self) -> tuple[str, str]:
        return self.field, self.value
