ensure gh || return


gh.search-my-repo() {
    # use gh cli helper, need a read-only api token
    gh search repos \
        --owner=quantumsnowball \
        --sort=updated \
        --order=desc \
        --limit=20 \
        --json name,language,visibility,updatedAt \
        --template '{{range .}}{{
            tablerow 
            (.name | autocolor "white") 
            (printf "%.7s" .language | autocolor "yellow") 
            (.visibility | autocolor "cyan") 
            (printf "%.9s" (timeago .updatedAt) | autocolor "green")
        }}{{end}}' \
        "$@"
}

