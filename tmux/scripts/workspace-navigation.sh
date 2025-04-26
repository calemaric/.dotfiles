#!/bin/bash

# Select a directory using fzf
dir=$(find ~/git/ -mindepth 1 -maxdepth 1 -type d | fzf-tmux --prompt="Select directory: " --exit-0)

# Exit if no directory is selected
[ -z "$dir" ] && exit 0

# Open a new tmux window with the selected directory and optional command
if [ "$1" == "nvim" ]; then
  tmux new-window -c "$dir" nvim
else
  tmux new-window -c "$dir"
fi

