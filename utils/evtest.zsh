ensure evtest || return


alias evtest.list='evtest </dev/null 2>&1 | rg --color=never "^/dev/input/event"'
alias evtest.list-common="evtest.list | rg --color=never '2.4G|BOW|WLS.Ltd|PXN|PG-9099'"
