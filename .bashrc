# ~/.bashrc
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

alias ls='lsd --color=auto'
alias ll='lsd -la --color=auto'
alias grep='grep --color=auto'

powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. /usr/share/powerline/bindings/bash/powerline.sh

eval "$(fzf --bash)"
export FZF_CTRL_T_OPTS="
  --walker-skip .git,.venv,__pycache__,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
"

function runcpp() {
    g++ -o "$1" "$1.cpp"
}
