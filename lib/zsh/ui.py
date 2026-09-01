from typing import Any, Mapping, Protocol, Self, Sequence

from rich.console import Console, RenderableType
from rich.live import Live
from rich.table import Column, Table


class Cell(Protocol):
    @property
    def text(self) -> RenderableType: ...


class LiveTable:
    def __init__(
        self,
        # cells is a 2d sequence, cells[row][column] structure
        cells: list[Sequence[Cell]],
        *,
        # stub column
        stub_header: RenderableType = '',
        stubs: Sequence[RenderableType] | None = None,
        # cell columns
        # - if cell_columns is provided, will override related settings
        cell_columns: Sequence[Mapping[str, Any]] | None = None,
        cell_headers: Sequence[RenderableType] = (),
        # kwargs
        stub_column_kwargs: Mapping[str, Any] | None = None,
        cell_column_kwargs: Mapping[str, Any] | None = None,
        table_kwargs: Mapping[str, Any] | None = None,
        live_kwargs: Mapping[str, Any] | None = None,
    ) -> None:
        # data
        self._cells = cells
        self._stub_header = stub_header
        self._stubs = stubs
        self._cell_columns = cell_columns
        self._cell_headers = cell_headers
        # kwargs
        self._stub_column_kwargs = stub_column_kwargs or {}
        self._cell_column_kwargs = cell_column_kwargs or {}
        self._table_kwargs = table_kwargs or {}
        self._live_kwargs = live_kwargs or {}
        # rich live
        self._live = Live(self._renderer(), **self._live_kwargs)

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
            *(
                (Column(self._stub_header, **self._stub_column_kwargs), )
                if self._stubs is not None else
                ()
            ),
            *(
                (Column(**kw) for kw in self._cell_columns)
                if self._cell_columns is not None else
                (Column(cell_header, **self._cell_column_kwargs) for cell_header in self._cell_headers)
            ),
        ]
        # create a rich Table
        table = Table(*columns, **self._table_kwargs)
        # add row values based on the current state
        for i, row_cells in enumerate(self._cells):
            texts = [
                *((self._stubs[i],) if self._stubs is not None else ()),
                *(cell.text for cell in row_cells),
            ]
            table.add_row(*texts)

        # Table object giving back for render
        return table

    def update(self) -> None:
        self._live.update(self._renderer())

    def add_row(self, row: Sequence[Cell]) -> None:
        self._cells.append(row)
