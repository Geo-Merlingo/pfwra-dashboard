#!/bin/bash

set -e  # Exit on error
mkdir -p website/

# Define URLs
BASE_URL="https://pfwra.blob.core.windows.net/public"
FILES=("hexmap_2024.html" "bar_chart_2024.html" "summary_stats.json")

# Download each file
for FILE in "${FILES[@]}"; do
  curl -sSf "${BASE_URL}/${FILE}" -o "website/${FILE}"
done

# Git commit and push if there are changes
cd website
if git diff --quiet && git diff --cached --quiet; then
  echo "No changes to commit."
else
  cd ..
  git config user.name "github-actions[bot]"
  git config user.email "github-actions[bot]@users.noreply.github.com"
  git add website/
  git commit -m "Update dashboard resources $(date --iso-8601=minutes)"
  git push
fi
