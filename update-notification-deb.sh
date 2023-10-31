#!/bin/sh

count="$(apt-get --no-install-recommends dist-upgrade -sqq | grep -ce ^Inst)"
test "$count" != "0" && notify-send -t 30000 "$count available updates!"
