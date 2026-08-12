#!/bin/bash
for f in pages/*/*.md; do
  if [ "$f" != "pages/*/index.md" ]; then
    # Get filename without path and without extension
    filename=$(basename "$f" .md)
    # Remove leading numbers and hyphens
    clean_name=$(echo "$filename" | sed -E 's/^[0-9]+-//g')
    # Replace hyphens with spaces
    spaced_name=$(echo "$clean_name" | tr '-' ' ')
    # Capitalize each word
    title=$(echo "$spaced_name" | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')
    
    if [ "$filename" != "index" ]; then
      echo "Updating $f to title: $title"
      # Replace the existing title line with the new title
      sed -i -E "s/^title:.*$/title: $title/" "$f"
    fi
  fi
done
