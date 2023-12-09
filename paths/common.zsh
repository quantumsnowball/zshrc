# my own executable functions
export PATH=~/.scripts:$PATH
# pyenv
# export PATH=~/.pyenv/bin:$PATH
# yarn
export PATH=~/.yarn/bin:$PATH
# local
export PATH=~/.local/bin:$PATH

# gcloud
# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Repos/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/Repos/google-cloud-sdk/path.zsh.inc"; fi
# The next line enables shell command completion for gcloud.
if [ -f "$HOME/Repos/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/Repos/google-cloud-sdk/completion.zsh.inc"; fi
