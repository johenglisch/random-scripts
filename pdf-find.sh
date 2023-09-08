#!/bin/sh

exec locate '*.pdf' \
    | dmenu -i -l 15 \
    | xargs -r -I {} "${PDFVIEWER:-zathura}" '{}'
