#!/bin/sh

remove_aux_files()
{
    for ext in aux bbl blg dbj dvi log nav out ps snm toc fdb_latexmk fls synctex.gz
    do
        rm -vf "${1%%.tex}.$ext"
    done
}

if [ $# -eq 0 ]
then
    for file in *.tex
    do
        remove_aux_files "$file"
    done
else
    for file in "$@"
    do
        remove_aux_files "$file"
    done
fi
