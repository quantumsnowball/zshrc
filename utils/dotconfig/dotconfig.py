#!/usr/bin/env -S uv run
# /// script
# dependencies = [
#   "rich",
# ]
# ///

import asyncio
import random
from typing import Callable

import rich
from rich.live import Live
from rich.table import Table

# Types
Renderer = Callable[[], Table]


class Repo:
    # Exact repo directory names
    NAMES = (
        'zshrc',
        'nvim',
        'tmux',
        'workspace',
        'workspace-private',
    )

    def __init__(self, name: str, *, host: str) -> None:
        self._name = name
        self._host = host
        # State
        self._state = ''

    @property
    def state(self) -> str: return self._state

    async def pull(self, live: Live, renderer: Renderer) -> None:
        # Set initial state and update UI
        self._state = '[yellow]PULLING[/]'
        live.update(renderer())
        # Git pull command, starts in the repo directory, rebase and autostash
        git_cmd = f'git -C ~/.config/{self._name} pull --rebase --autostash'
        try:
            # Execute each SSH command asynchronously
            process = await asyncio.create_subprocess_exec(
                'ssh',
                '-A',                           # SSH agent forwarding, use the the current machine's ssh key for remote auth
                '-o', 'ConnectTimeout=10',      # Fast fail if device is offline
                '-o', 'BatchMode=yes',          # Prevent hanging on password prompts
                self._host,
                git_cmd,
                stdout=asyncio.subprocess.DEVNULL,
                stderr=asyncio.subprocess.PIPE,
            )
            # Wait for process to complete, communicate to get stdout or stderr
            _, stderr = await process.communicate()
            # Update state based on SSH return code
            if process.returncode == 0:
                # SUCCESS
                self._state = '[bold green]SUCCESS[/]'
            else:
                # FAILED, print failed message above the table
                self._state = '[bold red]FAILED[/]'
                live.console.print(f'\n[red]FAILED[/] Host: [yellow]{self._host}[/], Repo: [magenta]{self._name}[/]\n')
                live.console.print(stderr.decode())
        except Exception:
            # ERROR, on any exception, try to print it
            self._state = '[bold red]ERROR[/]'
            live.console.print_exception()
        finally:
            # Finally must update the table to reflect final state
            live.update(renderer())


class Host:
    # Exact ssh profile names
    NAMES = (
        's7',
        'a9',
        'a56',
    )

    def __init__(self, name: str) -> None:
        self._name = name
        # Each host handles all repos on that machine
        self._repos = [Repo(name, host=self._name) for name in Repo.NAMES]

    @property
    def repos(self) -> list[Repo]: return self._repos

    async def pull(self, live: Live, renderer: Renderer) -> None:
        # Gather each repo pulling themself
        tasks = [repo.pull(live, renderer) for repo in self._repos]
        await asyncio.gather(*tasks)


class Manager:
    def __init__(self) -> None:
        # Manager handles all the SSH hosts
        self._hosts = [Host(name) for name in Host.NAMES]

    def _renderer(self) -> Table:
        # Create a rich Table
        table = Table()
        # Add column headers
        table.add_column(f'[bold magenta]Repo[/] \\ [bold blue]Host[/]', width=20)
        for host_name in Host.NAMES:
            table.add_column(f'[bold cyan]{host_name}[/]', width=10)
        # Add row value based on the current state
        for i, repo_name in enumerate(Repo.NAMES):
            states = [host.repos[i].state for host in self._hosts]
            table.add_row(f'[bold white]{repo_name}[/]', *states)
        # Table object giving back for render
        return table

    async def run(self) -> None:
        # The Live object for rendering the Table
        with Live(self._renderer(), refresh_per_second=10) as live:
            # Gather each host pulling all their repos
            tasks = [host.pull(live, self._renderer) for host in self._hosts]
            await asyncio.gather(*tasks)


async def main() -> None:
    # Manager
    manager = Manager()
    await manager.run()


if __name__ == '__main__':
    # main
    asyncio.run(main())
