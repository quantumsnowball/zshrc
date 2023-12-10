import sys
import json
import subprocess


# help
usage = 'Usage: conda-diff ENV1 ENV2'


# args
args = sys.argv[1:]


# validate inputs
if len(args) != 2:
    print(usage)
    sys.exit(1)


# read conda list
def conda_list(env: str) -> set[str]:
    cmd = ('conda', 'list', '-n', env, '--json')
    stdout = subprocess.check_output(cmd)
    data = stdout.decode()
    packages = json.loads(data)
    names = {p['name'] for p in packages}
    return names


# calc result
env1, env2 = args
names1 = conda_list(env1)
names2 = conda_list(env2)
only_env1 = sorted(names1 - names2)
only_env2 = sorted(names2 - names1)
both_envs = sorted(names1 & names2)


# display result
SEP = '-'*50
BOUNDARY = '='*50


def display(title: str, names: list[str]) -> None:
    print(BOUNDARY)
    print(f'\t{title}')
    print(SEP)
    for name in names:
        print(name)
    print('\n')


display(f'Only in `{env1}`', only_env1)
display(f'Only in `{env2}`', only_env2)
display(f'Both in `{env1}` and `{env2}`', both_envs)
