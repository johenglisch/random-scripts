#!/bin/sh

tmux new-session -c "$PWD" -d \; rename-window -t0 sh \; new-window -n vi \; attach
