ensure atuin || return


atuin.sync-rebuild-purge-sync() {
    atuin sync
    atuin store rebuild history
    atuin store purge
    atuin sync
}
