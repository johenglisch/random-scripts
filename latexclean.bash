#! /bin/bash

auxfiles="aux bbl blg dbj dvi log nav out ps snm toc fdb_latexmk fls"

texfiles="$*"
[ -z "$texfiles" ] && texfiles="./*tex"

for file in $texfiles
do
    for ext in $auxfiles
    do
        rm -vf "${file%%.tex}.$ext"
    done
done
