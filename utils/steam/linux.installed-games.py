#!/usr/bin/env -S uv run
# /// script
# dependencies = [
#     "zsh",
#     "rich",
#     "vdf",
# ]
#
# [tool.uv.sources]
# zsh = { path = "../../lib", editable = true }
# ///

import re
from dataclasses import dataclass
from pathlib import Path
from typing import Self

import vdf
from zsh.ui import LiveTable


@dataclass
class Game:
    @dataclass
    class Info:
        text: str

    name: str
    app_id: Info
    launch_options: Info

    @classmethod
    def create(cls, name: str, app_id: str, launch_options: str = '') -> Self:
        return cls(name, cls.Info(app_id), cls.Info(launch_options))


def load_launch_options(steam_dirs: list[Path]) -> dict[str, str]:
    launch_options = {}
    app_id_pattern = re.compile(r'^\s*"(\d+)"\s*(?:\{)?\s*$')
    launch_opt_pattern = re.compile(r'^\s*"LaunchOptions"\s+"(.*?)"\s*$')

    for steam_dir in steam_dirs:
        steam_root = steam_dir.parent
        userdata_dir = steam_root / 'userdata'
        if not userdata_dir.is_dir():
            continue

        for user_dir in userdata_dir.iterdir():
            localconfig = user_dir / 'config' / 'localconfig.vdf'
            if not localconfig.is_file():
                continue
            try:
                content = localconfig.read_text(encoding='utf-8', errors='ignore')
                last_seen_id = None
                for line in content.splitlines():
                    stripped = line.strip()
                    app_match = app_id_pattern.match(stripped)
                    if app_match:
                        last_seen_id = app_match.group(1)
                        continue

                    opt_match = launch_opt_pattern.match(stripped)
                    if opt_match and last_seen_id:
                        launch_options[last_seen_id] = opt_match.group(1)
            except Exception:
                continue
    return launch_options


def load_non_steam_games(steam_dirs: list[Path]) -> list[Game]:
    games: list[Game] = []
    seen_app_ids: set[str] = set()

    for steam_dir in steam_dirs:
        steam_root = steam_dir.parent
        userdata_dir = steam_root / 'userdata'
        if not userdata_dir.is_dir():
            continue

        for user_dir in userdata_dir.iterdir():
            shortcuts_file = user_dir / 'config' / 'shortcuts.vdf'
            if not shortcuts_file.is_file():
                continue
            try:
                with open(shortcuts_file, 'rb') as f:
                    content = vdf.binary_load(f)
                    shortcuts = content.get('shortcuts', {})
                    for shortcut in shortcuts.values():
                        if not isinstance(shortcut, dict):
                            continue
                        name = shortcut.get('appname') or shortcut.get('AppName', '')
                        raw_app_id = shortcut.get('appid') or shortcut.get('AppID', '')
                        # convert to unsigned 32 bit int
                        app_id = str(int(raw_app_id) & 0xFFFFFFFF)
                        launch_options = shortcut.get('launchoptions') or shortcut.get('LaunchOptions', '')

                        if name and app_id not in seen_app_ids:
                            games.append(Game.create(name, app_id, launch_options))
                            seen_app_ids.add(app_id)
            except Exception:
                continue
    return games


def scan_for_games(steam_dirs: list[Path]) -> list[Game]:
    games: list[Game] = []
    seen_app_ids: set[str] = set()

    # load launch options from steam userdata config
    launch_options_map = load_launch_options(steam_dirs)

    # compile regex for appid and name extraction
    app_id_pattern = re.compile(r'appmanifest_(\d+)\.acf')
    name_pattern = re.compile(r'"name"\s+"([^"]+)"')

    for steam_dir in steam_dirs:
        if not steam_dir.is_dir():
            continue
        # iterate over all acf manifest files
        for manifest in steam_dir.glob('appmanifest_*.acf'):
            # extract appid from filename
            match = app_id_pattern.search(manifest.name)
            if not match:
                continue
            app_id: str = match.group(1)
            if app_id in seen_app_ids:
                continue
            try:
                content = manifest.read_text(encoding='utf-8', errors='ignore')
                name_match = name_pattern.search(content)
                if name_match:
                    name: str = name_match.group(1)
                    launch_options = launch_options_map.get(app_id, '')
                    games.append(Game.create(name, app_id, launch_options))
                    seen_app_ids.add(app_id)
            except Exception:
                continue

    # include non-steam games from shortcuts vdf
    non_steam_games = load_non_steam_games(steam_dirs)
    for game in non_steam_games:
        if game.app_id.text not in seen_app_ids:
            games.append(game)
            seen_app_ids.add(game.app_id.text)

    # sort case-insensitively by game name
    games.sort(key=lambda game: game.name.lower())

    return games


def main() -> None:
    # define potential steam installation paths
    steam_dirs = [
        Path.home() / '.local/share/Steam/steamapps',
        # Path.home() / '.steam/steam/steamapps',
        # Path.home() / '.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps',
    ]

    games = scan_for_games(steam_dirs)

    # print live table
    with LiveTable(
        [[game.app_id, game.launch_options] for game in games],
        stubs=[game.name for game in games],
        stub_header='[bold magenta]Game[/]',
        stub_column_kwargs=dict(style='bold white',),
        cell_headers=['App Id', 'Launch Options'],
        cell_column_kwargs=dict(
            header_style='bold magenta',
        ),
    ) as table:
        table.update()


if __name__ == '__main__':
    main()
