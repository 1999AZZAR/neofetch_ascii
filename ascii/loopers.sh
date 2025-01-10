#!/bin/bash

# Save the initial directory and cursor position
original_dir=$(pwd)
save_cursor_pos() {
    printf '\e[s' # Save cursor position
}

# Restore the original directory and cursor position
restore_state() {
    printf '\e[u' # Restore cursor position
    cd "$original_dir" || exit 1
}

# Cleanup function to handle script termination
cleanup() {
    restore_state
    clear
    exit
}

# Trap Ctrl+C and other signals to run cleanup
trap cleanup SIGINT SIGTERM

# Save initial cursor position
save_cursor_pos

# Function to display a file's content with a specified delay
display_file() {
    local file="$1"
    local delay="$2"

    # Get terminal size
    lines=$(tput lines)
    cols=$(tput cols)

    # Read the ASCII art content into an array
    IFS=$'\n' read -d '' -r -a art <"$file"

    # Calculate position for centering
    start_line=$(((lines - ${#art[@]}) / 2))
    start_col=$(((cols - ${#art[0]}) / 2))

    # Clear the terminal
    clear

    # Display ASCII art with leading spaces for centering
    for line in "${art[@]}"; do
        printf '\e[%s;%sH' "$start_line" "$start_col"
        printf ' %s\n' "$line"
        ((start_line++))
    done

    sleep "$delay"
}

# Help message
show_help() {
    echo "Usage: $0 [options]"
    echo
    echo "Options:"
    echo "  -f <file>       Display a specific file (no loop, use file number)."
    echo "  -r              Display all files in random order (loop)."
    echo "  -o              Display all files in order (loop). (Default behavior)"
    echo "  -fr <start:end> Display files from a range in random order."
    echo "  -fo <start:end> Display files from a range in order."
    echo "  -t <delay>      Set custom delay (in seconds)."
    echo "  -h              Show this help message."
}

# Parse command-line arguments
mode="ordered_loop" # Default to ordered loop
specific_file=""
range=""
custom_delay=""
while [[ "$#" -gt 0 ]]; do
    case $1 in
    -f)
        mode="specific"
        specific_file="$2"
        shift
        ;;
    -r) mode="random_loop" ;;
    -o) mode="ordered_loop" ;; # Explicit use of ordered loop
    -fr)
        mode="range_random"
        range="$2"
        shift
        ;;
    -fo)
        mode="range_ordered"
        range="$2"
        shift
        ;;
    -t)
        custom_delay="$2"
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

# Handle modes
case "$mode" in
"specific")
    file=$(printf "%03d.txt" "$specific_file")
    if [[ -f "$file" ]]; then
        delay="${custom_delay:-1.5}" # Use custom delay if set, otherwise default to 1.5
        display_file "$file" "$delay"
    else
        echo "Error: File '$file' not found."
    fi
    cleanup
    ;;
"random_loop")
    files=$(ls *.txt | shuf)
    delay="${custom_delay:-0.7}" # Use custom delay if set, otherwise default to 0.7
    while true; do
        for file in $files; do
            display_file "$file" "$delay"
        done
    done
    ;;
"ordered_loop")
    files=$(ls *.txt | sort)
    delay="${custom_delay:-0.7}" # Use custom delay if set, otherwise default to 0.7
    while true; do
        for file in $files; do
            display_file "$file" "$delay"
        done
    done
    ;;
"range_random" | "range_ordered")
    IFS=':' read -r start end <<<"$range"
    files=$(seq -f "%03g.txt" "$start" "$end" 2>/dev/null)
    files=$(echo "$files" | xargs -n1 ls 2>/dev/null) # Filter only existing files
    if [[ "$mode" == "range_random" ]]; then
        files=$(echo "$files" | shuf)
    fi
    delay="${custom_delay:-0.7}" # Use custom delay if set, otherwise default to 0.7
    while true; do
        for file in $files; do
            display_file "$file" "$delay"
        done
    done
    ;;
*)
    echo "Error: Invalid or missing mode."
    show_help
    cleanup
    ;;
esac
