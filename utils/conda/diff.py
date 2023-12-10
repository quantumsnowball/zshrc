import sys

# help
usage = 'Usage: conda-diff ENV1 ENV2'

# args
args = sys.argv[1:]

# validate inputs
if len(args) != 2:
    print(usage)
    sys.exit(1)

env1, env2 = args

print(env1, env2)
