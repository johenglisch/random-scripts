#!/bin/sh

sleep "${1-3600}" \
    && echo '' \
    && notify-send 'Get up and stretch your legs! o/'
