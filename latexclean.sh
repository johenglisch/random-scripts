#!/bin/sh

remove_aux_files()
{
    while read -r ext
    do
        rm -vf "${1%%.tex}.$ext"
    done <<EOF
adx
aux
bbl
bcf
blg
fdb_latexmk
fls
idx
ilg
ind
ldx
log
mw
out
run.xml
sdx
toc
xdv
EOF
}

if [ $# -eq 0 ]
then
    find . -name '*.tex' | while read -r file
    do
        remove_aux_files "$file"
    done
else
    for file in "$@"
    do
        remove_aux_files "$file"
    done
fi
