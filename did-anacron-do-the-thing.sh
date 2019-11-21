#!/bin/sh

pid="$(pidof anacron)"
if [ -n "$pid" ]
then
    echo "anacron pid: $pid"
else
    echo "anacron not running"
fi

echo

find /var/spool/anacron -type f | sort | while read -r fname
do
    if raw_date="$(cat "$fname")"
    then
        formatted_date="$(date -d "$raw_date" +'%a %d %b %Y')"
        echo "$(basename "$fname"):$formatted_date"
    fi
done | column -t -s:
