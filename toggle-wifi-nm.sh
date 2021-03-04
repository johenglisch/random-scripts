#!/bin/sh

case "$(nmcli radio wifi)" in
    disabled)
        nmcli radio wifi on \
            && notify-send 'wifi on'
        ;;
    enabled)
        nmcli radio wifi off \
            && notify-send 'wifi off'
        ;;
esac
