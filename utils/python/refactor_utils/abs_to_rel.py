import ast
import os
from pathlib import Path

import typer

app = typer.Typer()


def convert_import(
    node: ast.AST,
    current_path: Path,
    max_dots: int,
) -> ast.AST:
    """ Convert absolute import to relative import, restricted by max_dots """
    # only convert import from
    if not isinstance(node, ast.ImportFrom):
        return node
    # don't convert current relative import
    if not node.level == 0:
        return node
    # ensure module
    if not node.module:
        return node
    # Get the relative path using pathlib
    module_path = Path(*node.module.split('.'))
    try:
        relative_path = module_path.relative_to(current_path.parent, walk_up=True)
    except ValueError:
        return node

    # Count the number of dots in the relative path
    dot_count = relative_path.parts.count('..') + 1
    if dot_count > max_dots:
        return node
    parts = [p for p in relative_path.parts if p != '..']
    rel_names = '.'*dot_count + '.'.join(parts)
    rel_node = ast.ImportFrom(
        module=rel_names,
        names=node.names,
        level=dot_count,
    )
    return rel_node


def refactor_file(
    path: Path,
    max_dots: int,
) -> None:
    """ Refactor a single Python file to convert imports to relative ones """
    with open(path, 'r') as f:
        source = f.read()

    tree = ast.parse(source)

    # Traverse and refactor the imports
    for node in ast.walk(tree):
        if isinstance(node, (ast.ImportFrom, )):
            node = convert_import(node, path, max_dots)

    # Write the modified code back to the file
    modified_code = ast.unparse(tree)
    with open(path, 'w') as f:
        f.write(modified_code)


@app.command()
def refactor_project(
    current_dir: Path,
    max_dots: int = 2,
) -> None:
    """ Refactor all Python files in a project directory to use relative imports """
    for current_file in current_dir.rglob('*.py'):
        typer.echo(f'Refactoring {current_file}')
        refactor_file(current_file, max_dots)
    typer.echo(f"Refactoring completed for all Python files in {current_dir} with max {max_dots} dot(s) in relative imports.")


if __name__ == "__main__":
    app()
