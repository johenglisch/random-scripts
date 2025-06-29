#!/bin/sh

doi="$1"
case "$doi" in
    http://doi.org/*|https://doi.org/*)
        url="$doi"
        ;;
    doi.org/*)
        url="https://$doi"
        ;;
    */*)
        url="https://doi.org/$doi"
        ;;
    *)
        echo "doesn't look like a doi: $doi" 1>&2
        exit 1
        ;;
esac

exec curl -sL -H 'Accept: application/x-bibtex' "$url"
