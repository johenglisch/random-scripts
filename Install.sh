#!/bin/sh

PREFIX="${PREFIX:-$HOME/.local}"
MANPREFIX="${MANPREFIX:-$PREFIX/share/man}"

scripts="healthy-legs.bash latexclean.sh no-escape.sh pdf-find.sh url-watch.sh update-notification-deb.sh wname.sh"


cd "$(dirname "$0")" || exit

test -d "$PREFIX/bin" || mkdir -p "$PREFIX/bin"
test -d "$MANPREFIX/man1" || mkdir -p "$MANPREFIX/man1"

for f in $scripts
do
    bin_target="$PREFIX/bin/${f%.*}"
    cp -v "$f" "$bin_target"
    chmod +x "$bin_target"

    manpage="${f%.*}.1"
    test -f "$manpage" && cp -v "$manpage" "$MANPREFIX/man1"
done