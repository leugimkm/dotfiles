#
# ~/.bash_profile
#

export RANGER_LOAD_DEFAUTL_RC=FALSE

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  exec startx
fi
