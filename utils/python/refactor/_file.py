import difflib
from pathlib import Path

import libcst as cst
from rich.syntax import Syntax

from ._base import Transformer
from ._utils import ruff_isort

RichObjects = list[Syntax | str]


class File:
    def __init__(
        self,
        path: Path,
        max_dots: int,
        *,
        transformer_cls: type[Transformer],
    ) -> None:
        self.path = path
        self._transformer = transformer_cls(self.path, max_dots)

    def refactor(self, fix: bool, verbose: bool) -> RichObjects | None:
        output: RichObjects = []
        source = self.path.read_text()
        source_tree = cst.parse_module(source)
        modified_tree = source_tree.visit(self._transformer)
        if modified_tree.deep_equals(source_tree):
            return None
        if not fix:
            output.append(f'[[yellow]FIXABLE[/]] {self.path}')
            if verbose:
                output.append(Syntax(''.join(difflib.unified_diff(
                    source.splitlines(True),
                    modified_tree.code.splitlines(True)
                )), 'diff'))
        else:
            sorted_code = ruff_isort(modified_tree.code)
            self.path.write_text(sorted_code)
            output.append(f'[[green]FIXED[/]] {self.path}')
        return output
