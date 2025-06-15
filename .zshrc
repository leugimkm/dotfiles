# export PATH=/opt/homebrew/bin:$PATH
export XDG_CONFIG_HOME=$XDG_CONFIG_HOME

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

HISTSIZE=1024
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt correct
setopt no_beep

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

alias ls='lsd --color=always'
alias ll='lsd -la --color=always'
alias l='ls -l'
alias la='ls -a'
alias tree='lsd --tree'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h -d 1'
alias tobash="sudo chsh $USER -s /bin/bash"

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
zinit snippet OMZP::git
zinit snippet OMZP::command-not-found

autoload -U compinit && compinit

zinit cdreplay -q

eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

export PATH=$PATH:$HOME/.local/bin
POSH_THEME="custom"
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/themes/$POSH_THEME.omp.json)"

function runcpp() {
    g++ -o "$1" "$1.cpp"
}

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
#   exec startx
# fi
