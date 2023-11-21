#!/bin/sh

# TODO: hook up with history?
query="$(zenity --title 'Folder Opener 5000' --forms --text 'Where to?' --add-entry Folder)"
if [ -z "$query" ]
then
    exit
fi

only_dirs()
{
    # alternative idea:
    #  * include files in the fzf list, but output their dirname
    #  * also, give files a lower weight than dirs?
    while read -r f
    do
        test -d "$f" && echo "$f"
    done
}

choose_dir()
{
    locate -b -- "$1" \
        | grep -v '/\.' \
        | only_dirs \
        | dmenu -i -l 20
}

dest="$(choose_dir "$query")"
if [ -n "$dest" ]
then
    xdg-open "$dest"
fi
