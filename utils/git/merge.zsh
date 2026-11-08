git.merge-branch-into() {
    local source="${2:-$(git branch --show-current)}"
    local target="$1"

    # assert source and target is non-empty
    [[ -n "$source" ]] || { echo "${RED}Could not determine source branch${RESET}"; return 1; }
    [[ -n "$target" ]] || { echo "${RED}Target branch is required${RESET}"; return 1; }

    # create temp worktree pointing to $target
    local worktree="$(mktemp -d /tmp/git-worktree.XXXXXX)"
    git worktree add "$worktree" "$target" || return 1

    # create a merge commit
    git -C "$worktree" merge --no-ff $source -m "Merge $source into $target"
    local merge_status=$?

    # clean up temporary worktree anyways
    git worktree remove --force "$worktree"

    # report back the merge status
    return $merge_status
}
