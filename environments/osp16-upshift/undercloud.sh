#!/bin/bash

sudo dnf localinstall -y http://download.lab.bos.redhat.com/rcm-guest/puddles/OpenStack/rhos-release/rhos-release-latest.noarch.rpm
sudo rhos-release 16
sudo dnf install -y python3-tripleoclient git tmux

cat >~/.tmux.conf<<EOF
set-option -g prefix2 C-a
bind-key C-a send-prefix -2

# Pane border
set-option -g pane-active-border-style fg=green,bg=green

set -g set-titles on
set -g set-titles-string '#{pane_current_path}'
set -g automatic-rename on
set -g automatic-rename-format "#{pane_current_path}"
set-option -g pane-border-format '#{pane_index} "#{pane_current_path}"'
# setw pane-border-status bottom

# Source config
bind-key R source-file ~/.tmux.conf

# Zoom current pane
bind-key Z resize-pane -Z

# Set title
bind-key T command-prompt -p "title:" "set set-titles-string %1"

# vi mode
set-window-option -g mode-keys vi
EOF

