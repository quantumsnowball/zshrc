# /// script
# dependencies = [
#     "rich",
#     "typer",
#     "httpx",
# ]
# ///

from abc import ABC, abstractmethod
from dataclasses import dataclass
from pathlib import Path

import httpx
import typer
from rich import print

app = typer.Typer(help='fetch official steam library assets for non-steam shortcuts')


@dataclass(kw_only=True)
class Asset:
    save_name: str
    url: str

    def download(self, client: httpx.Client, *, save_dir: Path, force: bool = False) -> None:
        save_dir.mkdir(parents=True, exist_ok=True)
        save_path = save_dir / self.save_name

        # check if asset exists and skip if force is false
        if save_path.exists() and not force:
            print(f'[yellow]skipped {save_path} (already exists)[/]')
            return

        try:
            response = client.get(self.url)
            response.raise_for_status()
            save_path.write_bytes(response.content)
            print(f'[green]saved {save_path}[/]')
        except httpx.HTTPStatusError as err:
            print(f'[red]{save_path} (http {err.response.status_code})[/]')
        except Exception as err:
            print(f'[red]{save_path} ({err})[/]')


@dataclass
class Downloader(ABC):
    app_id: int
    shortcut_id: int
    user_id: int | None

    def __post_init__(self) -> None:
        # grid dir
        def _default_grid_dir() -> Path:
            steam_base = Path.home() / '.local/share/Steam/userdata'
            if not steam_base.exists():
                print(f'[red]steam userdata directory not found at {steam_base}[/]')
                raise typer.Exit(1)

            # locate the first user folder (numerical directory)
            user_dirs = [d for d in steam_base.iterdir() if d.is_dir() and d.name.isdigit()]
            if not user_dirs:
                print(f'[red]no user directories found inside {steam_base}[/]')
                raise typer.Exit(1)

            # sort to guarantee predictable fallback
            selected_user = sorted(user_dirs)[0]
            return selected_user / 'config/grid'
        self.grid_dir = Path.home() / f'.local/share/Steam/userdata/{self.user_id}/config/grid' if self.user_id else _default_grid_dir()

    @abstractmethod
    def download(self, client: httpx.Client, *, force: bool) -> None:
        ...


@dataclass
class Icon(Downloader):
    def download(self, client: httpx.Client, *, force: bool) -> None:
        save_dir = self.grid_dir / 'icons'
        save_path = save_dir / f'{self.shortcut_id}_icon.png'

        # check if target icon exists before querying API
        if save_path.exists() and not force:
            print(f'[yellow]skipped {save_path} (already exists)[/]')
            return

        # icon hash
        def _icon_hash() -> str | None:
            # query steamcmd public mirror for exact appinfo metadata
            url = f'https://api.steamcmd.net/v1/info/{self.app_id}'
            try:
                response = client.get(url)
                response.raise_for_status()
                data = response.json()

                # traverse appinfo JSON tree: data -> <app_id> -> common -> clienticon
                app_data = data.get('data', {}).get(str(self.app_id), {})
                common_data = app_data.get('common', {})
                return common_data.get('clienticon')
            except Exception:
                return None

        icon_hash = _icon_hash()
        if not icon_hash:
            print('[red]failed to query steamcmd api for icon hash, cancelled download[/]')
            return

        # download
        asset = Asset(
            save_name=f'{self.shortcut_id}_icon.png',
            url=f'https://cdn.cloudflare.steamstatic.com/steamcommunity/public/images/apps/{self.app_id}/{icon_hash}.ico',
        )
        asset.download(client, save_dir=save_dir, force=force)


@dataclass
class Artwork(Downloader):
    def __post_init__(self) -> None:
        super().__post_init__()

        # create assets
        steamstatic_url = 'https://shared.fastly.steamstatic.com/store_item_assets/steam/apps'
        base_path = f'{steamstatic_url}/{self.app_id}'
        self.cover = Asset(
            save_name=f'{self.shortcut_id}p.jpg',
            url=f'{base_path}/library_600x900.jpg',
        )
        self.background = Asset(
            save_name=f'{self.shortcut_id}_hero.jpg',
            url=f'{base_path}/library_hero.jpg',
        )
        self.logo = Asset(
            save_name=f'{self.shortcut_id}_logo.png',
            url=f'{base_path}/logo.png',
        )
        self.wide_cover = Asset(
            save_name=f'{self.shortcut_id}.jpg',
            url=f'{base_path}/header.jpg',
        )
        self.assets = (self.cover, self.background, self.logo, self.wide_cover)

    def download(self, client: httpx.Client, *, force: bool) -> None:
        for asset in self.assets:
            asset.download(client, save_dir=self.grid_dir, force=force)


@app.command(
    no_args_is_help=True,
)
def main(
    app_id: int = typer.Option(..., '--app-id', help='official steam app id'),
    shortcut_id: int = typer.Option(..., '--shortcut-id', help='non-steam shortcut id'),
    user_id: int | None = typer.Option(None, '--user-id', help='override default steam user id'),
    force: bool = typer.Option(False, '--force', help='overwrite artwork and icon if they already exist'),
):
    '''
    download official store assets into steam grid config directory
    '''
    # download
    with httpx.Client(follow_redirects=True) as client:
        # download icon
        icon = Icon(app_id, shortcut_id, user_id)
        icon.download(client, force=force)
        # download artwork
        artwork = Artwork(app_id, shortcut_id, user_id)
        artwork.download(client, force=force)


if __name__ == '__main__':
    app()
