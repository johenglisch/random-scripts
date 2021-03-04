#!/bin/sh

get_clipboard()
{
    xclip -o -selection clipboard 2>/dev/null \
        || xclip -o -selection primary 2>/dev/null \
        || xclip -o -selection secondary
}

url="$(get_clipboard)"
test -n "$url" && "${MPLAYER:-mpv}" -- "$url"
