# ~/.bashrc
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

set -o vi

alias ls='lsd --color=auto'
alias ll='lsd -la --color=auto'
alias l='ls -l'
alias la='ls -a'
alias tree='lsd --tree'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h -d 1'
alias tozsh="sudo chsh $USER -s /bin/zsh"

POSH_THEME="custom"
eval "$(oh-my-posh init bash --config ~/.config/ohmyposh/themes/$POSH_THEME.omp.json)"
eval "$(fzf --bash)"
export FZF_CTRL_T_OPTS="
  --walker-skip .git,.venv,__pycache__,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
"

function runcpp() {
    g++ -o "$1" "$1.cpp"
}
