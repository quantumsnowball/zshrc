# /// script
# dependencies = [
#     "typer",
#     "httpx",
# ]
# ///

from pathlib import Path

import httpx
import typer

app = typer.Typer(help='fetch official steam library assets for non-steam shortcuts')


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
    if user_id:
        grid_dir = Path.home() / f'.local/share/Steam/userdata/{user_id}/config/grid'
    else:
        grid_dir = get_default_grid_dir()

    grid_dir.mkdir(parents=True, exist_ok=True)
    typer.echo(f'target directory: {grid_dir}')

    # base artwork assets: (output_filename, cdn_url)
    assets = [
        (f'{shortcut_id}p.jpg', f'https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/{app_id}/library_600x900.jpg'),
        (f'{shortcut_id}_hero.jpg', f'https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/{app_id}/library_hero.jpg'),
        (f'{shortcut_id}_logo.png', f'https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/{app_id}/logo.png'),
        (f'{shortcut_id}.jpg', f'https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/{app_id}/header.jpg'),
    ]

    with httpx.Client(follow_redirects=True) as client:
        # resolve icon hash dynamically via steamcmd metadata
        icon_hash = fetch_client_icon_hash(client, app_id)
        if icon_hash:
            # fetch both .ico and .png variants from steam cdn
            icon_url_ico = f'https://cdn.cloudflare.steamstatic.com/steamcommunity/public/images/apps/{app_id}/{icon_hash}.ico'
            # save the ico file as png
            assets.append((f'{shortcut_id}_icon.png', icon_url_ico))
        else:
            typer.echo('  [warn] clienticon hash not found in appinfo')

        for filename, url in assets:
            dest_path = grid_dir / filename
            try:
                response = client.get(url)
                response.raise_for_status()
                dest_path.write_bytes(response.content)
                typer.echo(f'  [ok] saved {filename}')
            except httpx.HTTPStatusError as err:
                typer.echo(f'  [fail] {filename} (http {err.response.status_code})')
            except Exception as err:
                typer.echo(f'  [fail] {filename} ({err})')

    typer.echo('done')


if __name__ == '__main__':
    app()
