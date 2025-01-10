#!/bin/bash
REPO_URL="https://github.com/1999AZZAR/neofetch_ascii"
REPO_DIR="$HOME/.local/share/neofetch_ascii"
CONFIG_DIR="$HOME/.config"

set -e
trap 'echo "Error occurred. Exiting..."; exit 1' ERR

# Detect user's shell and set the configuration file
if [[ $SHELL =~ "zsh" ]]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [[ $SHELL =~ "bash" ]]; then
    SHELL_CONFIG="$HOME/.bashrc"
else
    echo "Unsupported shell. Only Bash and Zsh are supported."
    exit 1
fi

# Check for required commands
for cmd in git neofetch; do
    if ! command -v $cmd &>/dev/null; then
        echo "Error: $cmd is not installed"
        exit 1
    fi
done

# Clone or update the repository
if [ -d "$REPO_DIR" ]; then
    cd "$REPO_DIR"
    git pull
else
    git clone "$REPO_URL" "$REPO_DIR"
    cd "$REPO_DIR"
fi

# Copy configuration files
mkdir -p "$CONFIG_DIR/neofetch" "$CONFIG_DIR/sakura"
cp -f config.conf "$CONFIG_DIR/neofetch/"
cp -f sakura.conf "$CONFIG_DIR/sakura/"

# Link the ASCII directory
sudo ln -sfn "$REPO_DIR/ascii" /usr/ascii

# Ensure loopers.sh is executable
chmod +x /usr/ascii/loopers.sh

# Add the custom caller function to the shell configuration
if ! grep -q "ascii()" "$SHELL_CONFIG"; then
    echo "Adding 'ascii' function to $SHELL_CONFIG"
    cat <<'EOF' >>"$SHELL_CONFIG"

# Custom ASCII Caller Function
ascii() {
    # Save the current directory
    local original_dir=\$(pwd)

    # Change to the ASCII art directory
    cd /usr/ascii/ || {
        echo "Error: /usr/ascii/ directory not found."
        return 1
    }

    # Call the loopers.sh script with passed arguments
    ./loopers.sh "\$@"

    # Restore the original directory
    cd "\$original_dir" || {
        echo "Error: Unable to return to the original directory."
        return 1
    }
}
EOF
    echo "Run 'source $SHELL_CONFIG' to apply changes."
else
    echo "'ascii' function is already present in $SHELL_CONFIG."
fi

echo "Installation complete!"
