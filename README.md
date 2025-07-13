# My Rice for Neofetch

A repository containing my setup for Neofetch.

## Installation

### Automatic Installation

Run the installer:

```bash
curl -sSL https://raw.githubusercontent.com/1999AZZAR/neofetch_ascii/master/install.sh | bash
```

After installation, reload your shell configuration:

- If you use Bash:
  
  ```bash
  source ~/.bashrc
  ```
- If you use Zsh:
  
  ```bash
  source ~/.zshrc
  ```

### Manual Installation

Follow these steps to install manually:

1. **Clone the repository:**

   ```bash
   git clone https://github.com/1999AZZAR/neofetch_ascii.git ~/.local/share/neofetch_ascii
   ```

2. **Place `config.conf` in the Neofetch configuration directory:**
   
   ```bash
   mkdir -p ~/.config/neofetch
   cp ~/.local/share/neofetch_ascii/config.conf ~/.config/neofetch/
   ```

3. **Create a symbolic link for the `ascii` folder:**
   
   ```bash
   mkdir -p ~/Pictures
   ln -sfn ~/.local/share/neofetch_ascii/ascii ~/Pictures/ascii
   ```

4. **Ensure `loopers.sh` has executable permissions:**
   
   ```bash
   chmod +x ~/Pictures/ascii/loopers.sh
   ```

5. **Add the `ascii` function to your shell configuration (`~/.bashrc` or `~/.zshrc`):**

   ```bash
   ascii() {
       # Save the current directory
       local original_dir=$(pwd)
   
       # Change to the ASCII art directory
       cd "$HOME/Pictures/ascii/" || {
           echo "Error: $HOME/Pictures/ascii/ directory not found."
           return 1
       }
   
       # Call the loopers.sh script with passed arguments
       ./loopers.sh "$@"
   
       # Restore the original directory
       cd "$original_dir" || {
           echo "Error: Unable to return to the original directory."
           return 1
       }
   }
   ```

6. **Reload your shell configuration:**
  
   ```bash
   source ~/.bashrc  # Or `source ~/.zshrc` for Zsh
   ```

## How to Use

#### Running Looper (`loopers.sh`)

You can use the `ascii` function to invoke the `loopers.sh` script from any directory.

#### Command-Line Options for `loopers.sh`

1. **Default Behavior (Ordered Loop):**
   
   ```bash
   ascii -o
   ```
   
   Displays all files in `$HOME/Pictures/ascii/` in alphabetical order with a default delay of **0.7 seconds**.

2. **Specific File Display:**
   
   ```bash
   ascii -f <file_number>
   ```
   
   Displays a specific file (e.g., `ascii -f 1` displays `001.txt`) with a default delay of **1.5 seconds**.

3. **Custom Delay:**
   Use the `-t` flag to set a custom delay (in seconds):
   
   ```bash
   ascii -f 1 -t 2
   ```
   
   Displays `001.txt` with a delay of **2.0 seconds**.

4. **Random Loop:**
   
   ```bash
   ascii -r
   ```
   
   Displays all files in random order with a default delay of **0.7 seconds**.

5. **Range Display (Ordered or Random):**
   
   ```bash
   ascii -fr <start:end>
   ascii -fo <start:end>
   ```
   
   Displays files in the specified range (`start` to `end`) either in random (`-fr`) or ordered (`-fo`) mode.

#### Example Commands

- Display `001.txt` with a custom delay:
  
  ```bash
  ascii -f 1 -t 1.8
  ```

- Loop through all files randomly:
  
  ```bash
  ascii -r
  ```

- Display files 5 to 10 in order:
  
  ```bash
  ascii -fo 5:10
  ```

- Display files 20 to 30 randomly with a delay of 2 seconds:
  
  ```bash
  ascii -fr 20:30 -t 2
  ```

## Demo

### Use Case

[![asciicast](https://asciinema.org/a/kvIYKfWWprJeNAWB0E86Z7s7X.svg)](https://asciinema.org/a/kvIYKfWWprJeNAWB0E86Z7s7X)

### Looper

[![asciicast](https://asciinema.org/a/RVnWXlRwS1GLoHTbfL0teIeHM.svg)](https://asciinema.org/a/RVnWXlRwS1GLoHTbfL0teIeHM)

> **Warning:**
> This setup includes content that is primarily for mature audiences (18+). Proceed at your own risk.