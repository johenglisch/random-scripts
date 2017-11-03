#! /bin/bash
set -euo pipefail
IFS=$'\n\t'


if [ -z "${REPOS:-}" ]
then
    echo 'Error: $REPOS is not set.' >&2
    exit 1
fi

IFS=';'
for dir in $REPOS
do
    echo "Repo: $dir"
    (cd "$dir" && git "$@") || (echo "Failed!" >&2)
    echo
done
