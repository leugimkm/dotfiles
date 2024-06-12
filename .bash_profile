#
# ~/.bash_profile
#

export RANGER_LOAD_DEFAUTL_RC=FALSE
export FZF_CTRl_T_OPTS="
  --preview 'bat -n --color=always {}'
"

[[ -f ~/.bashrc ]] && . ~/.bashrc
