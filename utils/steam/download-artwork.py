# /// script
# dependencies = [
#     "typer",
#     "httpx",
# ]
# ///

from dataclasses import dataclass
from pathlib import Path

import httpx
import typer

app = typer.Typer(help='fetch official steam library assets for non-steam shortcuts')


@dataclass
class Asset:
    save_name: str
    url: str

    def download(self, client: httpx.Client, *, save_dir: Path) -> None:
        save_path = save_dir / self.save_name
        try:
            response = client.get(self.url)
            response.raise_for_status()
            save_path.write_bytes(response.content)
            typer.echo(f'  [ok] saved {save_path}')
        except httpx.HTTPStatusError as err:
            typer.echo(f'  [fail] {save_path} (http {err.response.status_code})')
        except Exception as err:
            typer.echo(f'  [fail] {save_path} ({err})')


@dataclass
class Artwork:
    app_id: int
    shortcut_id: int

    def __post_init__(self) -> None:
        steamstatic_url = 'https://shared.fastly.steamstatic.com/store_item_assets/steam/apps'
        self.cover = Asset(f'{self.shortcut_id}p.jpg', f'{steamstatic_url}/{self.app_id}/library_600x900.jpg')
        self.background = Asset(f'{self.shortcut_id}_hero.jpg', f'{steamstatic_url}/{self.app_id}/library_hero.jpg')
        self.logo = Asset(f'{self.shortcut_id}_logo.png', f'{steamstatic_url}/{self.app_id}/logo.png')
        self.wide_cover = Asset(f'{self.shortcut_id}.jpg', f'{steamstatic_url}/{self.app_id}/header.jpg')
        self.assets = (self.cover, self.background, self.logo, self.wide_cover)

    def download(self, client: httpx.Client, grid_dir: Path) -> None:
        for asset in self.assets:
            asset.download(client, save_dir=grid_dir)


def get_default_grid_dir() -> Path:
    steam_base = Path.home() / '.local/share/Steam/userdata'
    if not steam_base.exists():
        typer.echo(f'error: steam userdata directory not found at {steam_base}', err=True)
        raise typer.Exit(1)

    # locate the first user folder (numerical directory)
    user_dirs = [d for d in steam_base.iterdir() if d.is_dir() and d.name.isdigit()]
    if not user_dirs:
        typer.echo(f'error: no user directories found inside {steam_base}', err=True)
        raise typer.Exit(1)

    # sort to guarantee predictable fallback
    selected_user = sorted(user_dirs)[0]
    return selected_user / 'config/grid'


def fetch_client_icon_hash(client: httpx.Client, app_id: int) -> str | None:
    # query steamcmd public mirror for exact appinfo metadata
    url = f'https://api.steamcmd.net/v1/info/{app_id}'
    try:
        response = client.get(url)
        response.raise_for_status()
        data = response.json()

        # traverse appinfo JSON tree: data -> <app_id> -> common -> clienticon
        app_data = data.get('data', {}).get(str(app_id), {})
        common_data = app_data.get('common', {})
        return common_data.get('clienticon')
    except Exception as err:
        typer.echo(f'  [warn] failed to query steamcmd api for icon: {err}')
        return None


@app.command(
    no_args_is_help=True,
)
def fetch(
    app_id: int = typer.Option(..., '--app-id', '-a', help='official steam app id'),
    shortcut_id: int = typer.Option(..., '--shortcut-id', '-s', help='non-steam shortcut id'),
    user_id: int | None = typer.Option(None, '--user-id', '-u', help='override default steam user id'),
):
    '''
    download official store assets into steam grid config directory
    '''
    grid_dir = Path.home() / f'.local/share/Steam/userdata/{user_id}/config/grid' if user_id else get_default_grid_dir()
    grid_dir.mkdir(parents=True, exist_ok=True)
    typer.echo(f'target directory: {grid_dir}')

    # download
    with httpx.Client(follow_redirects=True) as client:
        # download icon
        icon_hash = fetch_client_icon_hash(client, app_id)
        icon = Asset(f'{shortcut_id}_icon.png', f'https://cdn.cloudflare.steamstatic.com/steamcommunity/public/images/apps/{app_id}/{icon_hash}.ico')
        icon.download(client, save_dir=Path.home()/'Downloads')
        # download artwork
        artwork = Artwork(app_id, shortcut_id)
        artwork.download(client, grid_dir)


if __name__ == '__main__':
    app()
