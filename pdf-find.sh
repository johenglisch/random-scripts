#!/bin/sh

locate '*.pdf' \
    | dmenu -i -l 15 \
    | xargs -r -I {} "${PDFVIEWER:-zathura}" '{}'
