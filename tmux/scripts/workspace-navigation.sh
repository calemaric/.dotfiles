#!/bin/bash

# Select a directory using fzf
dir=$(find ~/git/ -mindepth 1 -maxdepth 1 -type d | fzf-tmux --prompt="Select directory: " --exit-0)

# Exit if no directory is selected
[ -z "$dir" ] && exit 0


if [ "$1" == "nvim" ]; then
  nvim_running=$(tmux list-panes -a -F "#{window_id}:#{pane_current_path}:#{pane_current_command}" | grep ":$dir:nvim$" | head -n 1 | cut -d: -f1)

  if [ -n "$nvim_running" ]; then
    tmux select-window -t "$nvim_running"
    exit 0
  fi

  # Open a new tmux window with nvim in the selected directory
  tmux new-window -c "$dir" nvim
else
  window_id=$(tmux list-windows -F "#{window_id}:#{pane_current_path}:#{pane_current_command}" | grep ":$dir:bash$" | head -n 1 | cut -d: -f1)

  if [ -n "$window_id" ]; then
    # Switch to the existing window
    tmux select-window -t "$window_id"
    exit 0
  fi

  # Open a new tmux window in the selected directory
  tmux new-window -c "$dir"
fi
