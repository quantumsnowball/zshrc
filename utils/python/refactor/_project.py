import concurrent.futures as futures
from functools import partial
from pathlib import Path

from pathspec import PathSpec
from rich.syntax import Syntax

from ._base import Transformer
from ._file import File
from ._utils import console


class Project:
    def __init__(
        self,
        root_dir: Path,
        *,
        transformer_cls: type[Transformer],
        max_dots: int,
        pattern: str,
        gitignore: bool,
        ignore: list[str],
    ) -> None:
        self.root_dir = root_dir
        self._transformer_cls = transformer_cls
        self._max_dots = max_dots
        self._pattern = pattern
        gitignore_spec = PathSpec.from_lines('gitwildmatch', [
            line
            for raw_line in (self.root_dir/'.gitignore').read_text().splitlines()
            if (line := raw_line.strip()) and not line.startswith("#")
        ]) if gitignore else PathSpec([])
        ignore_spec = PathSpec.from_lines('gitwildmatch', ignore)
        self._ignore_spec = gitignore_spec + ignore_spec

    def _worker(self, path: Path, max_dots: int, fix: bool, verbose: bool) -> list[Syntax | str] | None:
        file = File(path, max_dots, transformer_cls=self._transformer_cls)
        return file.refactor(fix, verbose)

    def refactor(self, fix: bool, verbose: bool) -> None:
        paths_selected_by_pattern = self.root_dir.rglob(self._pattern)
        paths_not_ignored = [p for p in paths_selected_by_pattern if not self._ignore_spec.match_file(p)]
        with futures.ProcessPoolExecutor() as executor:
            results = executor.map(
                partial(self._worker, max_dots=self._max_dots, fix=fix, verbose=verbose),
                sorted(paths_not_ignored),
            )
            for result in results:
                if not result:
                    continue
                for rich_obj in result:
                    console.print(rich_obj)
