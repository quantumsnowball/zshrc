# editor
ensure nvim && export EDITOR="nvim"

# gemini
if [[ -f ~/.gemini ]]; then
    source ~/.gemini
fi
# proxy
if [[ -f ~/.gemini-http-proxy ]]; then
    source ~/.gemini-http-proxy
fi
