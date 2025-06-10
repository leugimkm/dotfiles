WALLPAPER_DIR="$HOME/pictures/wallpapers"
swww img "$(find $WALLPAPER_DIR -type f | shuf -n 1)" --transition-type center
