WALLPAPER_DIR="$HOME/Pictures/wallpapers"
swww img "$(find $WALLPAPER_DIR -type f | shuf -n 1)" --transition-type center
