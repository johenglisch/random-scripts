#! /bin/sh

xprop -root \
    | awk '/^_NET_ACTIVE_WINDOW/ {print $5}' \
    | xargs -r xprop -id \
    | sed -nE '/^_NET_WM_NAME/ s/^[^"]*"(.*)"$/\1/p'
