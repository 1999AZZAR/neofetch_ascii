#!/bin/bash

# Function to clean up and exit
cleanup() {
    clear
    exit
}

# Trap Ctrl+C to run the cleanup function
trap cleanup SIGINT

# Function to display a file's content
display_file() {
    local file="$1"

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

    sleep 0.7
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
    echo "  -h              Show this help message."
}

# Parse command-line arguments
mode="ordered_loop" # Default to ordered loop
specific_file=""
range=""
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
        display_file "$file"
    else
        echo "Error: File '$file' not found."
    fi
    exit
    ;;
"random_loop")
    files=$(ls *.txt | shuf)
    while true; do
        for file in $files; do
            display_file "$file"
        done
    done
    ;;
"ordered_loop")
    files=$(ls *.txt | sort)
    while true; do
        for file in $files; do
            display_file "$file"
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
    while true; do
        for file in $files; do
            display_file "$file"
        done
    done
    ;;
*)
    echo "Error: Invalid or missing mode."
    show_help
    exit 1
    ;;
esac
