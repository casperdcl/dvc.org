#!/usr/bin/env bash
set -euo pipefail

repo="$(dirname "$(realpath "$(dirname "$0")")")"
pushd "$repo"

differ="git diff $(git merge-base HEAD origin/master)"
changed="$($differ --name-only -- '*.css' '*.js' '*.jsx' '*.md' '*.tsx' '*.ts' '*.json')"

[ -z "$changed" ] && exit 0

echo "$changed" | while read -r file ; do
  # check whole file
  # "$(dirname "$0")"/link-check.sh "$file"
  # check just changed lines
  echo -n "$file:"
  "$(dirname "$0")"/link-check.sh <($differ -U0 -- "$file" | grep '^\+')
done

popd
