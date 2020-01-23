#!/bin/sh

if [ -z "$1" ]
then
    echo "usage: $(basename "$0") filename" >&2
    exit 1
fi

resolution="$(ffprobe \
    -v error \
    -select_streams v:0 \
    -show_entries stream=width,height \
    -of csv=s=x:p=0 \
    "$1")" || exit 1

if [ "$resolution" != 1920x1080 ]
then
    echo "$1: ($resolution) resolution is not full hd" >&2
    exit
fi

filepath="$(readlink -f "$1")"

dir="$(dirname "$filepath")"
base="$(basename "$filepath")"
bare_name="${base%.*}"
ext="${base##*.}"

tmp_file="$(mktemp -u -p "${TMPDIR:-$dir}" "$bare_name-XXXXXX.$ext")"

if ffmpeg -v warning -i "$filepath" -vf scale=-1:720 "$tmp_file" </dev/null
then
    mv "$tmp_file" "$filepath"
fi
