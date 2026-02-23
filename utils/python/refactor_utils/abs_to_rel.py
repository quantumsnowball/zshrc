import difflib
import importlib.util
from pathlib import Path
from typing import Annotated

import libcst as cst
from pathspec import PathSpec
from rich.console import Console
from rich.syntax import Syntax
from typer import Argument, Option, Typer

app = Typer()
console = Console(highlight=False)


class AbsToRelImportTransformer(cst.CSTTransformer):
    def __init__(self, current_path: Path, max_dots: int):
        self.current_path = current_path
        self.max_dots = max_dots

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
        try:
            import_result = importlib.util.find_spec(module_string)
        except ModuleNotFoundError:
            import_result = None

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


class File:
    def __init__(self, path: Path, max_dots: int) -> None:
        self.path = path
        self._transformer = AbsToRelImportTransformer(self.path, max_dots)

    def refactor(self, fix: bool, verbose: bool) -> None:
        source = self.path.read_text()
        source_tree = cst.parse_module(source)
        modified_tree = source_tree.visit(self._transformer)
        if modified_tree.deep_equals(source_tree):
            return
        if not fix:
            console.print(f'[[yellow]FIXABLE[/]] {self.path}')
            if verbose:
                console.print(Syntax(''.join(difflib.unified_diff(
                    source.splitlines(True),
                    modified_tree.code.splitlines(True)
                )), 'diff'))
            return
        # self._path.write_text(modified_tree.code)
        console.print(f'[[green]FIXED[/]] {self.path}')


class Project:
    def __init__(
        self,
        root_dir: Path,
        *,
        max_dots: int,
        pattern: str,
        gitignore: bool,
        ignore: list[str],
    ) -> None:
        self.root_dir = root_dir
        self._max_dots = max_dots
        self._pattern = pattern
        gitignore_spec = PathSpec.from_lines('gitwildmatch', [
            line
            for raw_line in (self.root_dir/'.gitignore').read_text().splitlines()
            if (line := raw_line.strip()) and not line.startswith("#")
        ]) if gitignore else PathSpec([])
        ignore_spec = PathSpec.from_lines('gitwildmatch', ignore)
        self._ignore_spec = gitignore_spec + ignore_spec

    def refactor(self, fix: bool, verbose: bool) -> None:
        paths_selected_by_pattern = self.root_dir.rglob(self._pattern)
        paths_not_ignored = [p for p in paths_selected_by_pattern if not self._ignore_spec.match_file(p)]
        for path in paths_not_ignored:
            File(path, self._max_dots).refactor(fix, verbose)


@app.command(no_args_is_help=True)
def refactor_project(
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
        max_dots=max_dots,
        pattern=pattern,
        gitignore=gitignore,
        ignore=ignore,
    ).refactor(fix, verbose)


if __name__ == "__main__":
    app()
