import concurrent.futures as futures
from functools import partial
from pathlib import Path

from pathspec import PathSpec

from ._base import TransformerFactory
from ._file import File, RichObjects
from ._utils import console


class Project:
    def __init__(
        self,
        root_dir: Path,
        *,
        transformer_factory: TransformerFactory,
        pattern: str,
        gitignore: bool,
        ignore: list[str],
    ) -> None:
        self.root_dir = root_dir
        self._transformer_factory = transformer_factory
        self._pattern = pattern
        self._gitignore = gitignore
        ignore_spec = PathSpec.from_lines('gitwildmatch', ignore)
        self._ignore_spec = self._gitignore_spec + ignore_spec

    @property
    def _gitignore_spec(self) -> PathSpec:
        gitignore_path = self.root_dir/'.gitignore'
        if not gitignore_path.exists() or not self._gitignore:
            return PathSpec([])
        return PathSpec.from_lines('gitwildmatch', [
            line
            for raw_line in (self.root_dir/'.gitignore').read_text().splitlines()
            if (line := raw_line.strip()) and not line.startswith('#')
        ])

    def _worker(self, path: Path, fix: bool, verbose: bool) -> RichObjects | None:
        file = File(path, transformer_factory=self._transformer_factory)
        return file.refactor(fix, verbose)

    def refactor(self, fix: bool, verbose: bool, debug: bool) -> None:
        paths_selected_by_pattern = self.root_dir.rglob(self._pattern)
        paths_not_ignored = [p for p in paths_selected_by_pattern if not self._ignore_spec.match_file(p)]
        if debug:
            for path in paths_not_ignored:
                if result := self._worker(path, fix, verbose):
                    for rich_obj in result:
                        console.print(rich_obj)
        else:
            with futures.ProcessPoolExecutor() as executor:
                results = executor.map(
                    partial(self._worker, fix=fix, verbose=verbose),
                    sorted(paths_not_ignored),
                )
                for result in results:
                    if not result:
                        continue
                    for rich_obj in result:
                        console.print(rich_obj)
