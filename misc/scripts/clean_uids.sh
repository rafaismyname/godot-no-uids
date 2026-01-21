#!/bin/bash
# clean_uids.sh
# Removes [uid="uid://..."] tags from Godot 4.x .tscn and .trepo files,
# and removes the corresponding .uid files.
#
# Usage: ./clean_uids.sh

# 1. Find all .tscn and .tres files
find . -type f \( -name "*.tscn" -o -name "*.tres" \) -print0 | while IFS= read -r -d '' file; do
    # Check if the file contains a uid tag
    if grep -q 'uid="uid://' "$file"; then
        echo "Cleaning UIDs from $file"
        # Use perl for in-place replacement as regex handling is consistent
        # This regex looks for [ext_resource ... uid="uid://..." ...] and removes the uid part
        # It also handles the header descriptor [gd_scene ... uid="uid://..." ...]
        # Note: This is a basic regex. Complex multi-line tags might need more robust parsing,
        # but Godot usually keeps these on one line.
        
        # Remove uid="..." from tags
        perl -i -pe 's/ ?uid="uid:\/\/[a-zA-Z0-9]+"?//g' "$file"
    fi
done

# 2. Delete all *.uid files containing the cache
echo "Deleting .uid files..."
find . -name "*.uid" -type f -delete

echo "UID cleanup complete."
