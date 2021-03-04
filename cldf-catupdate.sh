#!/bin/sh

checkout_latest()
{
    cd "$1" || return

    git fetch
    v="$(git tag | sort -Vr | head -n1)"
    git checkout "$v"
}


cat_file="${XDG_CONFIG_HOME:-$HOME/.config}/cldf/catalog.ini"

sed -nE 's/.*=(.*)/\1/p' "$cat_file" | while read -r repo
do
    echo "$repo" 1>&2
    checkout_latest "$repo"
done
