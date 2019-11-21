#!/bin/sh

url="$(echo "$1" | tr -d '\n')"

if [ -z "$url" ]
then
    echo "usage: $(basename "$0") url" >&2
    exit
fi

if ! echo "$url" | grep -qE "[^:/][:/][^/]+/[^/]+$"
then
    echo "Url must follow the pattern 'url/user/repo' or 'url:user/repo'" >&2
    exit
fi

repos_root="${REPOS_DIR-$HOME/repos}"
username="$(echo "$url" | sed -E -e 's/^.*[:/]([^/]+)\/([^/]+)$/\1/')"
reponame="$(echo "$url" | sed -E -e 's/^.*[:/]([^/]+)\/([^/]+)$/\2/')"

git clone "$url" "$repos_root/$username/$reponame"
