zinit ice depth=1
zinit light romkatv/powerlevel10k


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || {
   
# normal settings loaded first
source ~/.p10k.zsh

#
# Overriding p10k.zsh here
#
# custom color
# 1=red 2=green 3=yellow 4=blue 5=pink 6=cyan 7=white 8=grey
typeset -g POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND=8
typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_BACKGROUND=8  # 8=grey, 9=pink 
typeset -g POWERLEVEL9K_CONTEXT_BACKGROUND=8
typeset -g POWERLEVEL9K_ANACONDA_BACKGROUND=7
typeset -g POWERLEVEL9K_ANACONDA_BACKGROUND=7
typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND=7
#
# FIXME: Horrific mess when resizing terminal window
# - ref: https://github.com/romkatv/powerlevel10k/blob/dce00cdb5daaa8a519df234a7012ba3257b644d4/README.md#horrific-mess-when-resizing-terminal-window
# Temp solution: 
# - disable any connecting lines
typeset -g POWERLEVEL9K_SHOW_RULER=false.
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR=' '
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX=''
typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX=''
typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX=''
# - disable right prompt
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
# Workaround:
# - restore some right prompt info to the left prompt, fields refer to ~/.p10k.zsh
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
# =========================[ Line #1 ]=========================
# left prompt default
os_icon                 # os identifier
dir                     # current directory
vcs                     # git status
# right prompt migrate here
virtualenv              # python virtual environment (https://docs.python.org/3/library/venv.html)
anaconda                # conda environment (https://conda.io/)
status                  # exit code of the last command
command_execution_time  # duration of the last command
context                 # user@hostname
# =========================[ Line #2 ]=========================
newline                 # \n
prompt_char             # prompt symbol
)

}
