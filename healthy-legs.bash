#!/bin/bash

sleep "${1-1h}" \
    && echo -e "\a" \
    && notify-send 'Get up and stretch your legs! o/'
