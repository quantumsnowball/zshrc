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

import re
from pathlib import Path


def main():
    # define potential steam installation paths
    steam_dirs = [
        Path.home() / '.local/share/Steam/steamapps',
        # Path.home() / '.steam/steam/steamapps',
        # Path.home() / '.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps',
    ]

    games = []
    seen_appids = set()

    # compile regex for appid and name extraction
    appid_pattern = re.compile(r'appmanifest_(\d+)\.acf')
    name_pattern = re.compile(r'"name"\s+"([^"]+)"')

    for steam_dir in steam_dirs:
        if not steam_dir.is_dir():
            continue

        # iterate over all acf manifest files
        for manifest in steam_dir.glob('appmanifest_*.acf'):
            # extract appid from filename
            match = appid_pattern.search(manifest.name)
            if not match:
                continue
            appid = match.group(1)

            if appid in seen_appids:
                continue

            try:
                content = manifest.read_text(encoding='utf-8', errors='ignore')
                name_match = name_pattern.search(content)
                if name_match:
                    name = name_match.group(1)
                    games.append((name, appid))
                    seen_appids.add(appid)
            except Exception:
                continue

    # sort case-insensitively by game name
    games.sort(key=lambda x: x[0].lower())

    # print formatted output
    for name, appid in games:
        print(f'{name:<50} | {appid}')


if __name__ == '__main__':
    main()
