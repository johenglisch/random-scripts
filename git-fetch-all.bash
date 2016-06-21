#! /bin/bash
set -euo pipefail
IFS=$'\n\t'


function fetch-repo() {
    echo "Fetching '$*'"
    (cd "$*" && git fetch > /dev/null && git status -sb) || (echo "Failed!" >&2)
    echo
}


if [ -z "${REPOS:-}" ]
then
    echo 'Error: $REPOS is not set.' >&2
    exit 1
fi

IFS=';'
for dir in $REPOS
do
    fetch-repo "$dir"
done
