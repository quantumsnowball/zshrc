#!/usr/bin/env -S uv run
# /// script
# dependencies = [
#   "rich",
# ]
# ///

import asyncio
import random
from typing import Callable

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
        # Construct the target git pull command
        git_cmd = f'git -C ~/.config/{self._name} pull --rebase --autostash'
        try:
            # Execute SSH asynchronously
            process = await asyncio.create_subprocess_exec(
                'ssh',
                '-A',                           # SSH agent forwarding, use the the current machine's ssh key for remote auth
                '-o', 'ConnectTimeout=10',      # Fast fail if device is offline
                '-o', 'BatchMode=yes',          # Prevent hanging on password prompts
                self._host,
                git_cmd,
                stdout=asyncio.subprocess.DEVNULL,
                stderr=asyncio.subprocess.DEVNULL,
            )
            # Wait for process to complete
            await process.wait()
            # Update state based on SSH return code
            self._state = '[bold green]SUCCESS[/]' if process.returncode == 0 else '[bold red]FAILED[/]'
        except Exception:
            self._state = '[bold red]ERROR[/]'
        finally:
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
        self._repos = [Repo(name, host=self._name) for name in Repo.NAMES]

    @property
    def repos(self) -> list[Repo]: return self._repos

    async def pull(self, live: Live, renderer: Renderer) -> None:
        # Gather each repo pulling themself
        tasks = [repo.pull(live, renderer) for repo in self._repos]
        await asyncio.gather(*tasks)


class Manager:
    def __init__(self) -> None:
        self._hosts = [Host(name) for name in Host.NAMES]

    def _renderer(self) -> Table:
        # Create a rich Table
        table = Table()
        # Add column headers
        table.add_column('Host', style='bold white', width=20)
        for host_name in Host.NAMES:
            table.add_column(host_name, style='bold cyan', width=10)
        # Add row value based on the current state
        for i, repo_name in enumerate(Repo.NAMES):
            states = [host.repos[i].state for host in self._hosts]
            table.add_row(repo_name, *states)
        # Table object giving back for render
        return table

    async def pull(self) -> None:
        # The Live object for rendering the Table
        with Live(self._renderer(), refresh_per_second=10) as live:
            # Gather each host pulling all their repos
            tasks = [host.pull(live, self._renderer) for host in self._hosts]
            await asyncio.gather(*tasks)


async def main() -> None:
    # Manager can do the pull action
    manager = Manager()
    await manager.pull()


if __name__ == '__main__':
    # main
    asyncio.run(main())
