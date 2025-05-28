bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

HISTSIZE=5000
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
setopt no_beep

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

alias ls='lsd --color=always'
alias ll='lsd -la  --color=always'
alias l='ls -l'
alias la='ls -a'
alias tree='lsd --tree'

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

zinit snippet OMZP::git
# zinit snippet OMZP::sudo
# zinit snippet OMZP::archlinux
# zinit snippet OMZP::command-not-found

autoload -U compinit && compinit

zinit cdreplay -q

eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

export PATH=$PATH:$HOME/.local/bin
POSH_THEME="custom"
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/themes/$POSH_THEME.omp.json)"

# powerline-daemon -q
# . /usr/share/powerline/bindings/zsh/powerline.zsh

function runcpp() {
    g++ -o "$1" "$1.cpp"
}

# if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
#   exec startx
# fi
