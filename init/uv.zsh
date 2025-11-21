ensure uv || return


# global settings
# export UV_HTTP_TIMEOUT=300 # default is 30


# default venv
# please create the file ~/.uv/default-venv and put the venv name in it
UV_DIR=$HOME/.uv
VENV_DIR=$UV_DIR/venv/
DEFAULT_VENV_FILE=$UV_DIR/default-venv
VENV_NAME=$(cat "$DEFAULT_VENV_FILE")
VENV_PATH="$HOME/.uv/venv/$VENV_NAME/bin/activate"
[[ -f "$VENV_PATH" ]] && source "$VENV_PATH"
