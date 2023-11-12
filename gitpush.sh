#!/bin/bash

# File to update
CHANGELOG="CHANGELOG.md"

# Read the first line of the CHANGELOG to get the current version
current_version=$(awk '/^## [0-9]+\.[0-9]+\.[0-9]+/{print $2; exit}' $CHANGELOG)

# Extract major, minor, and patch numbers
IFS='.' read -r major minor patch <<<"$current_version"

# Increment the patch number
patch=$((patch + 1))

# New version
new_version="## $major.$minor.$patch"

# New content to add
NEW_CONTENT="$new_version\n- update\n"

# Append new content to the CHANGELOG
echo -e "$NEW_CONTENT" | cat - $CHANGELOG >temp && mv temp $CHANGELOG

## Update Pubspec.yaml

# File to update
PUBSPEC="pubspec.yaml"

# Check if the file exists
if [ ! -f "$PUBSPEC" ]; then
    echo "File not found: $PUBSPEC"
    exit 1
fi

# Extract the current version number
current_version=$(grep 'version:' $PUBSPEC | cut -d ' ' -f 2)

echo "Current version: $current_version"

# Break down the version into major, minor, and patch numbers
IFS='.' read -r major minor patch <<<"$current_version"

# Increment the patch number
patch=$((patch + 1))

# Construct the new version string
new_version="$major.$minor.$patch"

echo "New version: $new_version"

# Replace the old version with the new version in the file
# Note the '' after -i for macOS compatibility
sed -i '' "s/version: $current_version/version: $new_version/" $PUBSPEC

# Verify if the replacement was successful
grep 'version:' $PUBSPEC

# ファイルをステージングエリアに追加
git add .

# コミットメッセージとともにコミット
git commit -m 'exp'

# developブランチにプッシュ
git push origin develop

# publish
dart pub publish
