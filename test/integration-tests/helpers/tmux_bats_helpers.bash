#!/usr/bin/env bash

# tmux-gitbar: Git in tmux status bar
#
# Created by Aurélien Rainone
# github.com/aurelien-rainone/tmux-gitbar

# helpers functions for bats integration tests

# Append a 'set-option' cmd to tmux.conf
set_option_in_tmux_conf() {
  option="$1"
  value="$2"
  echo set-option -g "'$option'" "'$value'" >> "${TMUXCONF}"
}

# Append a 'set-window-option' cmd to tmux.conf
setw_option_in_tmux_conf() {
  option="$1"
  value="$2"
  echo set-window-option -g "'$option'" "'$value'" >> "${TMUXCONF}"
}

# Set gitbar location to left, in tmux-gitbar configuration file
set_tmgb_location_left() {

  TMGBCONF="$PWD/tmux-gitbar.conf"
  # In-place modification of tmux-gitbar.conf
  ed -s "$TMGBCONF" <<< $',s/\(TMGB_STATUS_LOCATION\)=.*/\\1=\'left\'\nw' > /dev/null
}

# Generate default tmux-gitbar.conf
gen_default_tmgb_conf() {

  TMGBCONF="$PWD/tmux-gitbar.conf"
  ./lib/generate-config.sh "${TMGBCONF}"
}
