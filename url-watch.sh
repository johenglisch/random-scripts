#!/bin/sh

get_clipboard()
{
    if [ "$XDG_SESSION_TYPE" = wayland ]
    then
        wl-paste
    else
        xclip -o -selection clipboard 2>/dev/null \
            || xclip -o -selection primary 2>/dev/null \
            || xclip -o -selection secondary
    fi
}

url="$(get_clipboard)"
test -n "$url" && "${MPLAYER:-mpv}" -- "$url"
