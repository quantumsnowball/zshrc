#!/usr/bin/env -S uv run
# /// script
# dependencies = [
#   "zsh",
#   "rich",
# ]
#
# [tool.uv.sources]
# zsh = { path = "../../lib", editable = true }
# ///


import asyncio

from zsh import ssh
from zsh.ui import LiveTable

HOST_NAMES = (
    's7',
    'a9',
    'a56',
    'quest2',
)

REPO_NAMES = (
    'zshrc',
    'nvim',
    'tmux',
    'workspace',
    'workspace-private',
)


class Repo:
    def __init__(self, name: str, *, host: str) -> None:
        self._name = name
        self._host = host
        # State
        self._text = '       '

    @property
    def text(self) -> str: return self._text

    async def pull(self, table: LiveTable) -> None:
        # set initial state and update UI
        self._text = '[yellow]PULLING[/]'
        table.update()
        try:
            # execute each SSH command asynchronously
            result = await ssh.exec(
                host=self._host,
                # Git pull command, starts in the repo directory, rebase and autostash
                cmd=f'git -C ~/.config/{self._name} pull --rebase --autostash'
            )
            # update state based on SSH return code
            if result.ok:
                # SUCCESS
                self._text = '[bold green]SUCCESS[/]'
            else:
                # FAILED, print failed message above the table
                self._text = '[bold red]FAILED[/]'
                table.console.print(f'\n[red]FAILED[/] Host: [yellow]{self._host}[/], Repo: [magenta]{self._name}[/]\n')
                table.console.print(result.stderr_str)
        except Exception:
            # ERROR, on any exception, try to print it
            self._text = '[bold red]ERROR[/]'
            table.console.print_exception()
        finally:
            # Finally must update the table to reflect final state
            table.update()


class Manager:
    def __init__(self) -> None:
        # the cells for LiveTable
        self._repos = [
            [
                Repo(repo_name, host=host_name)
                for host_name in HOST_NAMES
            ]
            for repo_name in REPO_NAMES
        ]

    async def run(self) -> None:
        with LiveTable(
            self._repos,
            stubs=REPO_NAMES,
            stub_header=f'[bold magenta]Repo[/] \\ [bold blue]Host[/]',
            stub_column_kwargs=dict(style='bold white',),
            cell_headers=HOST_NAMES,
            cell_column_kwargs=dict(
                header_style='bold cyan',
                justify='center',
                min_width=7,
            ),
        ) as table:
            tasks = [
                repo.pull(table) for row in self._repos for repo in row
            ]
            await asyncio.gather(*tasks)


async def main() -> None:
    # Manager
    manager = Manager()
    await manager.run()


if __name__ == '__main__':
    # main
    asyncio.run(main())
