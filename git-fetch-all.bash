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
    echo "Fetching '$dir'"
    (cd "$dir" && git fetch) || (echo "Failed!" >&2)
    echo
done
