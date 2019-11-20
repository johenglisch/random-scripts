#!/bin/sh

xclip -o | xargs -r -I {} "${MPLAYER:-mpv}" -- '{}'
