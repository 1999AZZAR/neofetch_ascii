#!/bin/bash
REPO_URL="https://github.com/1999AZZAR/neofetch_ascii"
REPO_DIR="$HOME/.local/share/neofetch_ascii"
CONFIG_DIR="$HOME/.config"

set -e
trap 'echo "Error occurred. Exiting..."; exit 1' ERR

for cmd in git neofetch; do
    if ! command -v $cmd &> /dev/null; then
        echo "Error: $cmd is not installed"; exit 1
    fi
done

[ -d "$REPO_DIR" ] && { cd "$REPO_DIR"; git pull; } || { git clone "$REPO_URL" "$REPO_DIR"; cd "$REPO_DIR"; }

mkdir -p "$CONFIG_DIR/neofetch" "$CONFIG_DIR/sakura"
cp -f config.conf "$CONFIG_DIR/neofetch/"
cp -f sakura.conf "$CONFIG_DIR/sakura/"
ln -sfn "$REPO_DIR/ascii" /usr/ascii

echo "Installation complete!"
