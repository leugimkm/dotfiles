#
# ~/.bash_profile
#

export RANGER_LOAD_DEFAUTL_RC=FALSE
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
"

[[ -f ~/.bashrc ]] && . ~/.bashrc
