#!/bin/sh
set -eu

session_name="$(basename "$PWD")"
git_watch='watch --color git diff --minimal --ignore-all-space --color'
git_width=30

tmux new-session -d -s "$session_name"

tmux split-window -t "$session_name:0" -h -l "$git_width" "$git_watch"

tmux select-pane -t "$session_name:0" -L
tmux -2 attach-session -t "$session_name"
