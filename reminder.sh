#!/bin/sh

TODO_FILE="${TODO_FILE-$HOME/TODO}"

test -s "$TODO_FILE" || exit

zenity --info --width=400 --title=Reminder --text="$(cat "$TODO_FILE")"
