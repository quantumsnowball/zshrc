import importlib.util
from functools import cache
from importlib.machinery import ModuleSpec
from pathlib import Path
from typing import Annotated

import libcst as cst
from typer import Argument, Option, Typer

from ._base import Transformer
from ._project import Project

app = Typer()


class Refactorer(Transformer):
    def leave_ImportFrom(self, original_node: cst.ImportFrom, updated_node: cst.ImportFrom) -> cst.ImportFrom:
        # skip absolute imports
        dot_count = len(updated_node.relative)
        if dot_count == 0:
            return updated_node

        # ensure there is a module
        if updated_node.module is None:
            return updated_node

        # restore absolute part of the module
        parts = self.current_path.parts[:-1]
        module_string = cst.Module(body=[]).code_for_node(updated_node.module)
        module_prefix = '.'.join(parts[:len(parts)-dot_count+1])
        new_module_str = '.'.join(filter(lambda x: len(x) > 0, [module_prefix, module_string]))

        # return the new libcst node
        return updated_node.with_changes(
            module=cst.parse_expression(new_module_str) if new_module_str else None,
            relative=[],
        )


@app.command(no_args_is_help=True)
def main(
    current_dir: Annotated[Path, Argument(help='target directory to refactor')],
    pattern: Annotated[str, Option(help='glob pattern to select files')] = '*.py',
    gitignore: Annotated[bool, Option(help='respect the .gitignore file')] = True,
    ignore: Annotated[list[str], Option(help='file ignore pattern(s), use git wild match')] = [],
    fix: Annotated[bool, Option('--fix', help='apply fix to the fixable file(s), use with care')] = False,
    verbose: Annotated[bool, Option('--verbose', '-v', help='display verbose info')] = False,
    debug: Annotated[bool, Option('--debug', help='enter debug mode, runs in single thread and process')] = False,
) -> None:
    Project(
        current_dir,
        transformer_factory=Refactorer,
        pattern=pattern,
        gitignore=gitignore,
        ignore=ignore,
    ).refactor(fix, verbose, debug)


if __name__ == "__main__":
    app()
