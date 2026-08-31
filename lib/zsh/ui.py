from typing import Any, Protocol, Self, Sequence

from rich.console import Console
from rich.live import Live
from rich.table import Column, Table


class TableCell(Protocol):
    @property
    def text(self) -> str: ...


class LiveTable:
    def __init__(
        self,
        # cells is a 2d sequence, cells[row][column] structure
        cells: Sequence[Sequence[TableCell]],
        *,
        # column headers is always shown
        column_headers: Sequence[str] = (),
        column_header_color: str = 'bold cyan',
        column_width: int = 10,
        # row headers can be omitted
        row_headers: Sequence[str] | None = None,
        row_header_color: str = 'bold white',
        stub_header: str = '',
        # kwargs
        table_kwargs: dict[str, Any] = {},
        live_kwargs: dict[str, Any] = {},
    ) -> None:
        self._cells = cells
        self._column_headers = column_headers
        self._column_header_color = column_header_color
        self._column_width = column_width
        self._row_headers = row_headers
        self._row_header_color = row_header_color
        self._stub_header = stub_header
        # rich
        self._table_kwargs = table_kwargs
        self._live = Live(self._renderer(), **live_kwargs)
        Column()

    @property
    def console(self) -> Console:
        return self._live.console

    def __enter__(self) -> Self:
        self._live.__enter__()
        return self

    def __exit__(self, *_) -> None:
        self._live.__exit__(*_)

    def _renderer(self) -> Table:
        # create columns
        columns = [
            *((Column(self._stub_header), ) if self._row_headers is not None else ()),
            *(Column(f'[{self._column_header_color}]{column_header}[/]', width=self._column_width) for column_header in self._column_headers)
        ]
        # Create a rich Table
        table = Table(*columns, **self._table_kwargs)
        # Add row value based on the current state
        for i, row_cells in enumerate(self._cells):
            texts = [cell.text for cell in row_cells]
            if self._row_headers is not None:
                texts = [f'[{self._row_header_color}]{self._row_headers[i]}[/]'] + texts
            table.add_row(*texts)

        # Table object giving back for render
        return table

    def update(self) -> None:
        self._live.update(self._renderer())
