#!/bin/sh

PREFIX="${PREFIX:-$HOME/.local}"
MANPREFIX="${MANPREFIX:-$PREFIX/share/man}"

cd "$(dirname "$0")" || exit

test -d "$PREFIX/bin" || mkdir -p "$PREFIX/bin"
test -d "$MANPREFIX/man1" || mkdir -p "$MANPREFIX/man1"

while read -r f
do
    bin_target="$PREFIX/bin/${f%.*}"
    cp -v "$f" "$bin_target"
    chmod +x "$bin_target"

    manpage="${f%.*}.1"
    test -f "$manpage" && cp -v "$manpage" "$MANPREFIX/man1"
done <<EOF
cldf-catupdate.pl
clone-url.pl
dmenu-emoji.pl
dmenu-open-github.pl
doibib.sh
ensmallen-video.sh
folder-opener-5000.sh
gui-here.sh
healthy-legs.sh
latexclean.pl
mpv-continue.pl
no-escape.sh
pdf-find.sh
pip-rebuild.pl
readout.pl
reminder.sh
tagesschau-themen.py
unicode-names.py
use-lens.py
update-notification-deb.sh
url-watch.sh
vish.sh
wname.sh
EOF
