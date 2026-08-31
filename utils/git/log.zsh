git.log() {
    git log --graph --all --color=always --abbrev-commit --decorate --date=relative --pretty=format:"%C(yellow)%h%Creset%C(auto)%d%Creset %s %C(magenta)%cr%Creset %C(blue)%G?%Creset"
}
git.log.grep() {
    git log --oneline --all -i --grep="$1"
}
git.log.diff.fzf() {
    git log -S "$1" --oneline --all -i |
        fzf --height=-1 \
            --preview-window=right,60% \
            --preview 'git show --color=always {1} | bat --color=always --style=auto' \
            --bind 'enter:execute(git show {1} | bat --color=always)'
}
git.blame.fzf() {
    file=$(git ls-files | fzf)
    [ -n "$file" ] && \
        git blame "$file" |
            fzf --height=-1 \
                --preview-window=bottom,60% \
                --preview 'git show {1} | bat --color=always --style=auto' \
                --bind 'enter:execute(git show {1} | bat --color=always)' \
}


