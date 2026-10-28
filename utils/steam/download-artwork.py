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
class Icon:
    app_id: int
    shortcut_id: int

    def download(self, client: httpx.Client, save_dir: Path = Path.home()/'Downloads') -> None:
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
            except Exception as err:
                typer.echo(f'  [warn] failed to query steamcmd api for icon: {err}')
                return None
        icon_hash = _icon_hash()

        # download
        asset = Asset(f'{self.shortcut_id}_icon.png', f'https://cdn.cloudflare.steamstatic.com/steamcommunity/public/images/apps/{self.app_id}/{icon_hash}.ico')
        asset.download(client, save_dir=save_dir)


@dataclass
class Artwork:
    app_id: int
    shortcut_id: int
    user_id: int | None

    def __post_init__(self) -> None:
        # grid dir
        def _default_grid_dir() -> Path:
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
        self.grid_dir = Path.home() / f'.local/share/Steam/userdata/{self.user_id}/config/grid' if self.user_id else _default_grid_dir()
        self.grid_dir.mkdir(parents=True, exist_ok=True)

        # create assets
        steamstatic_url = 'https://shared.fastly.steamstatic.com/store_item_assets/steam/apps'
        self.cover = Asset(f'{self.shortcut_id}p.jpg', f'{steamstatic_url}/{self.app_id}/library_600x900.jpg')
        self.background = Asset(f'{self.shortcut_id}_hero.jpg', f'{steamstatic_url}/{self.app_id}/library_hero.jpg')
        self.logo = Asset(f'{self.shortcut_id}_logo.png', f'{steamstatic_url}/{self.app_id}/logo.png')
        self.wide_cover = Asset(f'{self.shortcut_id}.jpg', f'{steamstatic_url}/{self.app_id}/header.jpg')
        self.assets = (self.cover, self.background, self.logo, self.wide_cover)

    def download(self, client: httpx.Client) -> None:
        for asset in self.assets:
            asset.download(client, save_dir=self.grid_dir)


@app.command(
    no_args_is_help=True,
)
def main(
    app_id: int = typer.Option(..., '--app-id', help='official steam app id'),
    shortcut_id: int = typer.Option(..., '--shortcut-id', help='non-steam shortcut id'),
    user_id: int | None = typer.Option(None, '--user-id', help='override default steam user id'),
):
    '''
    download official store assets into steam grid config directory
    '''
    # download
    with httpx.Client(follow_redirects=True) as client:
        # download icon
        icon = Icon(app_id, shortcut_id)
        icon.download(client)
        # download artwork
        artwork = Artwork(app_id, shortcut_id, user_id)
        artwork.download(client)


if __name__ == '__main__':
    app()
