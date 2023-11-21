#!/bin/sh

PREFIX="${PREFIX:-$HOME/.local}"
MANPREFIX="${MANPREFIX:-$PREFIX/share/man}"


while read -r f
do
    bin_target="$PREFIX/bin/${f%.*}"
    man_target="$MANPREFIX/man1/${f%.*}.1"

    test -f "$bin_target" && rm -v "$bin_target"
    test -f "$man_target" && rm -v "$man_target"
done <<EOF
cldf-catupdate.sh
clone-url.sh
dmenu-open-github.pl
doibib.sh
ensmallen-video.sh
folder-opener-5000.sh
healthy-legs.sh
latexclean.sh
no-escape.sh
pdf-find.sh
pip-rebuild.pl
reminder.sh
tagesschau-themen.py
unicode-names.py
update-notification-deb.sh
url-watch.sh
vish.sh
wname.sh
EOF
