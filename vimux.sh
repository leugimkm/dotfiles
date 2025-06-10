#!/bin/zsh

SESSION="vimux"
WINDOW="editor"
FILE="$1"

if [ -z "$FILE" ]; then
  echo "Use: $0 filename.py"
  exit 1
fi

if ! tmux has session -t $SESSION 2>/dev/null; then
  tmux new-session -d -s $SESSION -n $WINDOW "vim $FILE"
  tmux split -window -v -p 30 -t $SESSION:$WINDOW
fi

tmux attach -t $SESSION
