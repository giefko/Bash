#!/bin/bash

# Function to get font details (name and version) from font file
get_font_details() {
    font_file="$1"
    font_name=$(fc-scan --format="%{fullname}" "$font_file" 2>/dev/null)
    font_version=$(fc-scan --format="%{fontversion}" "$font_file" 2>/dev/null)
    echo "Font Name: $font_name, Version: $font_version"
}

# Specify the path to the specific folder containing font files
specific_folder="/Users/efk/Desktop/terde/terde"

# Check if the specific folder exists
if [ -d "$specific_folder" ]; then
    # Get font files in the specific folder and its subfolders
    font_files=$(find "$specific_folder" -type f \( -iname "*.otf" -o -iname "*.ttf" \) -depth)

    # Loop through each font file to get its details
    for font_file in $font_files; do
        get_font_details "$font_file"
    done
else
    echo "The specified folder '$specific_folder' does not exist."
fi
