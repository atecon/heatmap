#!/usr/bin/env bash
set -euo pipefail

# Usage: replace_pkg_name.sh NEW_NAME [PLACEHOLDER]
# Replaces PLACEHOLDER (default: {{PKG_NAME}}) with NEW_NAME in all text files
# and renames files/directories whose names contain PLACEHOLDER.

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 NEW_NAME [PLACEHOLDER]"
  exit 2
fi

REPLACEMENT="$1"
PLACEHOLDER="${2:-{{PKG_NAME}}}"

# Make sure we run from repository root (optional) - user can run from anywhere
ROOT_DIR="$(pwd)"

echo "Replacing placeholder: '$PLACEHOLDER' -> '$REPLACEMENT' in contents and filenames under: $ROOT_DIR"

# 1) Replace inside text files (skip binaries and .git)
export LC_ALL=C
find . -type f -not -path './.git/*' -print0 | while IFS= read -r -d '' file; do
  # Skip if file is not a readable regular file
  [ -r "$file" ] || continue

  # Use grep -Iq to skip binary files (returns 0 for text files)
  if grep -Iq . -- "$file"; then
    # Only attempt replacement if placeholder exists in file
    if grep -Fq -- "$PLACEHOLDER" -- "$file"; then
      # Use Perl for safe in-place replacement and to handle special chars
      # \\Q and \\E quote metacharacters in both pattern and replacement
      perl -0777 -pe "s/\Q${PLACEHOLDER}\E/\Q${REPLACEMENT}\E/g" -i -- "$file"
      echo "Updated: $file"
    fi
  fi
done

# 2) Rename files and directories whose names contain the placeholder
# Use -depth so we rename children before parents
find . -depth -name "*${PLACEHOLDER}*" -print0 | while IFS= read -r -d '' path; do
  dir="$(dirname -- "$path")"
  name="$(basename -- "$path")"
  newname="${name//${PLACEHOLDER}/${REPLACEMENT}}"
  newpath="$dir/$newname"

  # Avoid overwriting existing paths
  if [ -e "$newpath" ]; then
    echo "Skipping rename (target exists): $path -> $newpath"
  else
    mv -- "$path" "$newpath"
    echo "Renamed: $path -> $newpath"
  fi
done

echo "Done."
