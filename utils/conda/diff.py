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
only_env1 = names1 - names2
only_env2 = names2 - names1
both_envs = names1 & names2


# display result
def display(title: str, names: set[str]) -> None:
    print(f'\n{title}:\n')
    for name in names:
        print(name)


display(f'Only in {env1}', only_env1)
display(f'Only in {env2}', only_env2)
display(f'Exists in both {env1} and {env2}', both_envs)
