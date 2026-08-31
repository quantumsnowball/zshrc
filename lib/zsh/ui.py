from typing import Any, Protocol, Self, Sequence

from rich.console import Console, RenderableType
from rich.live import Live
from rich.style import StyleType
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
        # stub column
        stub_head: RenderableType = '',
        stubs: Sequence[RenderableType] | None = None,
        # cell columns
        column_headers: Sequence[RenderableType] = (),
        # kwargs
        stub_column_kwargs: dict[str, Any] = dict(),
        cell_column_kwargs: dict[str, Any] = dict(),
        table_kwargs: dict[str, Any] = dict(),
        live_kwargs: dict[str, Any] = dict(),
    ) -> None:
        self._cells = cells
        self._stub_head = stub_head
        self._stubs = stubs
        self._column_headers = column_headers
        # rich
        self._stub_column_kwargs = stub_column_kwargs
        self._cell_column_kwargs = cell_column_kwargs
        self._table_kwargs = table_kwargs
        self._live = Live(self._renderer(), **live_kwargs)

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
            *((Column(self._stub_head, **self._stub_column_kwargs), ) if self._stubs is not None else ()),
            *(Column(column_header, **self._cell_column_kwargs) for column_header in self._column_headers)
        ]
        # Create a rich Table
        table = Table(*columns, **self._table_kwargs)
        # Add row value based on the current state
        for i, row_cells in enumerate(self._cells):
            texts = [cell.text for cell in row_cells]
            if self._stubs is not None:
                texts = [self._stubs[i]] + texts
            table.add_row(*texts)

        # Table object giving back for render
        return table

    def update(self) -> None:
        self._live.update(self._renderer())
