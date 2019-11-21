#!/bin/sh

PREFIX="${PREFIX:-$HOME/.local}"
MANPREFIX="${MANPREFIX:-$PREFIX/share/man}"

scripts="healthy-legs.sh
latexclean.sh
no-escape.sh
pdf-find.sh
url-watch.sh
update-notification-deb.sh
wname.sh"


echo "$scripts" | while read -r f
do
    bin_target="$PREFIX/bin/${f%.*}"
    man_target="$MANPREFIX/man1/${f%.*}.1"

    test -f "$bin_target" && rm -v "$bin_target"
    test -f "$man_target" && rm -v "$man_target"
done
