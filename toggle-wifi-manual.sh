#! /bin/sh

if [ "$(pgrep toggle-wifi | wc -l)" -gt 2 ]
then
    echo toggle-wifi is already running 1>&2
    exit 1
fi

user=johannes
uid=1000

interface="$(ip link | grep -o -E 'wlp[0-9]+s[0-9]+' | head -n1)"

if ip link show "$interface" | grep -q DOWN
then
    sudo -u "$user" \
        DISPLAY=:0 "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$uid/bus" \
        notify-send 'wifi on'
    echo unblock wlan
    rfkill unblock wlan
    echo start wpa_supplicant
    systemctl start "wpa_supplicant@$interface"
    echo start dhclient
    dhclient "$interface"
else
    sudo -u "$user" \
        DISPLAY=:0 "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$uid/bus" \
        notify-send 'wifi off'
    echo stop dhclient
    dhclient -x "$interface"
    echo stop wpa_supplicant
    systemctl stop "wpa_supplicant@$interface"
    echo block wlan
    rfkill block wlan
fi
