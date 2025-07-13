# My Rice for Neofetch

A repository containing my setup Neofetch.

## Installation

### Automatic Installation

Run the installer:

```bash
curl -sSL https://raw.githubusercontent.com/1999AZZAR/neofetch_ascii/master/install.sh | bash
```

After installation:

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

1. Place `config.conf` in the Neofetch configuration directory:
   
   ```
   /home/[username]/.config/neofetch/
   ```
   
   or wherever your Neofetch config file is located.

2. Copy the `ascii` folder and its contents to the `$HOME/Pictures/` directory:
   
   ```
   $HOME/Pictures/
   ```

3. Ensure `loopers.sh` has executable permissions:
   
   ```bash
   chmod +x $HOME/Pictures/ascii/loopers.sh
   ```

### How to Use

#### Running Looper (`loopers.sh`)

You can use the `ascii` function to invoke the `loopers.sh` script from any directory.

- Add the following function to your shell configuration (`~/.bashrc`, `~/.zshrc`, etc.):
  
  ```bash
  ascii() {
      # Save the current directory
      local original_dir=$(pwd)
  
      # Change to the ASCII art directory
      cd $HOME/Pictures/ascii/ || {
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

- Reload your shell configuration:
  
  ```bash
  source ~/.bashrc  # Or `source ~/.zshrc` for Zsh
  ```

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
