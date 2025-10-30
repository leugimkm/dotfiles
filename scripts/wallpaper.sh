#!/bin/bash

DIR="$HOME/Pictures/wallpapers"
FILES=$(ls "$DIR")
SELECTED=$(echo "$FILES" | fzf --height=~50% --border=double)

if [ -n "$SELECTED" ]; then
    feh --bg-scale "$DIR/$SELECTED"
else
    echo "No file selected."
fi
