#!/bin/bash

# ==============================================================================
# Looper - ASCII Art Slideshow
# Version: 2.0
#
# Displays ASCII art files in a centered, looping slideshow. It is designed
# to be called from any location in the filesystem.
# ==============================================================================

# --- Core Setup ---
# Find the script's own directory, making it callable from anywhere.
# This is the most critical part for portability.
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# !! CONFIGURATION: Set the directory where your ASCII art .txt files are located.
# By default, it's the same directory as the script.
ART_DIR="$SCRIPT_DIR"

# --- Cleanup & State Management ---
# Save cursor position on start.
printf '\e[s'

# Trap Ctrl+C (SIGINT) or termination signals (SIGTERM) to run cleanup.
trap cleanup SIGINT SIGTERM

cleanup() {
  printf '\e[u' # Restore cursor position.
  tput cnorm    # Ensure cursor is visible.
  clear         # Clear the screen.
  exit 0
}

# --- Main Functions ---

# Displays a file's content, properly centered on the terminal.
display_file() {
  local file_path="$1"
  local delay="$2"

  # Ensure the file is readable before proceeding.
  if [[ ! -r "$file_path" ]]; then
    return
  fi

  # Read the art into an array and find its dimensions.
  mapfile -t art <"$file_path"
  local art_height=${#art[@]}
  local art_width=0
  for line in "${art[@]}"; do
    ((${#line} > art_width)) && art_width=${#line}
  done

  # Get terminal dimensions.
  local term_height=$(tput lines)
  local term_width=$(tput cols)

  # Calculate top-left coordinates for centering.
  local start_line=$(((term_height - art_height) / 2))
  local start_col=$(((term_width - art_width) / 2))

  # Clear screen and hide cursor for clean display.
  clear
  tput civis

  # Print each line of the art at the calculated position.
  for line in "${art[@]}"; do
    # Move cursor to position, then print line.
    printf '\e[%s;%sH%s' "$start_line" "$start_col" "$line"
    ((start_line++))
  done

  sleep "$delay"
}

# Shows the help message.
show_help() {
  echo "Usage: $(basename "$0") [options]"
  echo
  echo "Options:"
  echo "  -o                Display all files in order (loop). [Default]"
  echo "  -r                Display all files in random order (loop)."
  echo "  -f <number>       Display a specific file by its number (e.g., 5 for 005.txt)."
  echo "  -fo <start:end>   Display a range of files in order (loop)."
  echo "  -fr <start:end>   Display a range of files in random order (loop)."
  echo "  -t <seconds>      Set a custom delay between files."
  echo "  -h                Show this help message."
}

# --- Argument Parsing ---
mode="ordered_loop"
delay=0.7
is_loop=true
files_to_process=()

while [[ "$#" -gt 0 ]]; do
  case $1 in
  -o) mode="ordered_loop" ;;
  -r) mode="random_loop" ;;
  -f)
    mode="specific"
    specific_file="$2"
    is_loop=false
    shift
    ;;
  -fo)
    mode="range_ordered"
    range="$2"
    shift
    ;;
  -fr)
    mode="range_random"
    range="$2"
    shift
    ;;
  -t)
    delay="$2"
    shift
    ;;
  -h)
    show_help
    exit 0
    ;;
  *)
    echo "Unknown option: $1"
    show_help
    exit 1
    ;;
  esac
  shift
done

# --- File List Preparation ---

case "$mode" in
specific)
  file_path=$(printf "%s/%03d.txt" "$ART_DIR" "$specific_file")
  [[ -f "$file_path" ]] && files_to_process=("$file_path")
  ;;

ordered_loop | random_loop)
  # Use a safe loop and globbing instead of parsing 'ls'.
  for f in "$ART_DIR"/*.txt; do
    [[ -e "$f" ]] && files_to_process+=("$f")
  done
  ;;

range_ordered | range_random)
  IFS=':' read -r start end <<<"$range"
  for i in $(seq "$start" "$end"); do
    file_path=$(printf "%s/%03d.txt" "$ART_DIR" "$i")
    [[ -f "$file_path" ]] && files_to_process+=("$file_path")
  done
  ;;
esac

# Shuffle the list if a random mode was selected.
if [[ "$mode" == "random_loop" || "$mode" == "range_random" ]]; then
  mapfile -t files_to_process < <(printf "%s\n" "${files_to_process[@]}" | shuf)
fi

# Check if we have any files to show.
if [[ ${#files_to_process[@]} -eq 0 ]]; then
  echo "Error: No ASCII art files found in '$ART_DIR'."
  [[ "$mode" == "specific" ]] && echo "Specifically, could not find file number '$specific_file'."
  exit 1
fi

# --- Main Execution Loop ---

while true; do
  for file in "${files_to_process[@]}"; do
    display_file "$file" "$delay"
  done

  # If not in a loop mode (like -f), exit after one pass.
  [[ "$is_loop" == false ]] && break
done

# Final cleanup before exiting naturally (e.g., after -f).
cleanup
