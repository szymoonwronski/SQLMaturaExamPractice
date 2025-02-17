#!/bin/bash

# Find all .txt files in subdirectories
find . -type f -name "*.txt" | while read file; do
    # Use tail to remove the first line and save changes
    tail -n +2 "$file" > "$file.tmp" && mv "$file.tmp" "$file"
    echo "Processed: $file"
done

echo "All .txt files have been processed."