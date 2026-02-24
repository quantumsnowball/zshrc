import importlib.util
from functools import cache, partial
from importlib.machinery import ModuleSpec
from pathlib import Path
from typing import Annotated

import libcst as cst
from typer import Argument, Option, Typer

from ._base import Transformer
from ._project import Project

app = Typer()


class Refactorer(Transformer):
    def __init__(self, current_path: Path, *, max_dots: int) -> None:
        super().__init__(current_path)
        self.max_dots = max_dots

    @cache
    def _try_import_module(self, module_string: str) -> ModuleSpec | None:
        try:
            return importlib.util.find_spec(module_string)
        except Exception:
            return None

    def leave_ImportFrom(self, original_node: cst.ImportFrom, updated_node: cst.ImportFrom) -> cst.ImportFrom:
        # skip relative imports
        if len(updated_node.relative) > 0:
            return updated_node

        # ensure there is a module (skip 'from . import x')
        if updated_node.module is None:
            return updated_node

        # try to import the module string
        module_string = cst.Module(body=[]).code_for_node(updated_node.module)
        module_strings = module_string.split('.')
        import_result = self._try_import_module(module_string)

        # skip builtin modules
        if import_result is not None:
            return updated_node

        # determine relative position and dot count
        module_path = Path(*module_strings)
        try:
            # Note: current_path must be absolute or relative to project root
            relative_path = module_path.relative_to(self.current_path.parent, walk_up=True)
        except ValueError:
            return updated_node
        dot_count = list(relative_path.parts).count('..') + 1

        # skip if dot count greater than max_dots allows
        if dot_count > self.max_dots:
            return updated_node

        # determine relative import module string
        remaining_parts = [p for p in relative_path.parts if p != '..']
        new_module_str = ".".join(remaining_parts)

        # return the new libcst node
        return updated_node.with_changes(
            module=cst.parse_expression(new_module_str) if new_module_str else None,
            relative=[cst.Dot() for _ in range(dot_count)]
        )


@app.command(no_args_is_help=True)
def main(
    current_dir: Annotated[Path, Argument(help='target directory to refactor')],
    max_dots: Annotated[int, Option('--max_dots', '-m', help='maximum allowed level of relative')] = 1,
    pattern: Annotated[str, Option(help='glob pattern to select files')] = '*.py',
    gitignore: Annotated[bool, Option(help='respect the .gitignore file')] = True,
    ignore: Annotated[list[str], Option(help='file ignore pattern(s), use git wild match')] = [],
    fix: Annotated[bool, Option('--fix', help='apply fix to the fixable file(s), use with care')] = False,
    verbose: Annotated[bool, Option('--verbose', '-v', help='display verbose info')] = False,
) -> None:
    Project(
        current_dir,
        transformer_factory=partial(Refactorer, max_dots=max_dots),
        pattern=pattern,
        gitignore=gitignore,
        ignore=ignore,
    ).refactor(fix, verbose)


if __name__ == "__main__":
    app()
