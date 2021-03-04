#!/bin/sh

if [ -z "$1" ]
then
    echo 'Where to?' 1>&2
    exit 1
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

locate -b -- "$1" \
    | grep -v '/\.' \
    | only_dirs \
    | fzf -1 --reverse --height=20 --no-sort
