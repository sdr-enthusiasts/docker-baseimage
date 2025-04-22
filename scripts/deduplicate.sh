#!/bin/bash

set -e
trap 'echo "[ERROR] Error in line $LINENO when executing: $BASH_COMMAND"' ERR

# use symlinks to save disk space when 2 directories have common files at the same relative path

if [[ -z "$1" ]] || [[ -z "$2" ]]; then
    echo "deduplicate.sh: 2 arguments required: dir not to be modified with similar data / dir in which to replace files with symlinks to save space"
    exit 1
fi

src="$1"
target="$2"


count=0
while read -r sub; do
    if diff -q "${src}${sub}" "${target}${sub}" &>/dev/null; then
        ln -sf "${src}${sub}" "${target}${sub}"
        count=$(( count + 1 ))
    fi
done < <(find "$target" -type f | sed -e "s#${target}##")

echo "deduplicate.sh: replaced ${count} identical files in ${target} with symlinks to ${src}, remaining size on disk: $(du -sh "$target")"
