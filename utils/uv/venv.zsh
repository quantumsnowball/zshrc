# venv
uv.venv.activate-local () {
    if [[ -f ./.venv/bin/activate ]]; then
        . ./.venv/bin/activate
    else
        echo "Error: ./.venv/bin/activate not found. No virtual environment activated."
    fi
}
alias uv.venv.ls='uv.venv-info'

uv.venv.activate() {
    local venv_name="${1:-python3}"
    local activate_path="$HOME/.uv/venv/$venv_name/bin/activate"
    if [[ -f "$activate_path" ]]; then
        source "$activate_path"
    else
        echo "${RED}Virtual environment not found: $venv_name${RESET}"
        return 1
    fi
}
