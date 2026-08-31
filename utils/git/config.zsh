git.config-summary() {
    echo "${CYAN}--- Git config summary ---${RESET}"
    git config --list --show-scope
}
git.global.set-default-user() {
    git config --global user.name "Quantum Snowball"
    git config --global user.email "quantum.snowball@gmail.com"
    git.config-summary
}
git.global.set-user() {
    if [[ $# -ne 2 ]] then
        echo "Usage: git.global.set-user <username> <email>"
        return 1
    fi
    git config --global user.name "$1"
    git config --global user.email "$2"
    git.config-summary
}
git.local.set-user() {
    if [[ $# -ne 2 ]] then
        echo "Usage: git.local.set-user <username> <email>"
        return 1
    fi
    git config --local user.name "$1"
    git config --local user.email "$2"
    git.config-summary
}
git.global.enable-auto-commit-signing() {
    # auto sign all commits
    git config --global commit.gpgsign true
    # use ssh key to sign commits
    git config --global gpg.format ssh
    git config --global gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers
    git config --global user.signingkey ~/.ssh/id_ed25519.pub
    #
    git.config-summary
}
git.global.edit-config() {
    [[ -f "$HOME/.gitconfig" ]] || { echo "Error: Global .gitconfig not found."; exit 1; }
    ${EDITOR:-vi} "$HOME/.gitconfig"
    git.config-summary
}
git.local.edit-config() {
    [[ -f ".git/config" ]] || { echo "Error: Local .git/config not found."; exit 1; }
    ${EDITOR:-vi} ".git/config"
    git.config-summary
}
git.local.origin-use-ssh-url() {
    current_url=$(git config --local remote.origin.url) &&
    new_url=${current_url/https:\/\/github.com\//git@github.com:} &&
    git config --local remote.origin.url $new_url &&
    git.config-summary | grep remote.origin.url
}
git.local.origin-use-https-url() {
    current_url=$(git config --local remote.origin.url) &&
    new_url=${current_url/git@github.com:/https:\/\/github.com\/} &&
    git config --local remote.origin.url $new_url &&
    git.config-summary | grep remote.origin.url
}

