# editor
ensure nvim && export EDITOR="nvim"

# gemini
if [[ -f ~/.gemini ]]; then
    source ~/.gemini
fi
# proxy
if [[ -f ~/.http-proxy ]]; then
    source ~/.http-proxy
fi
