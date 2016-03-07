#!/usr/bin/env bats

# tmux-gitbar: Git in tmux status bar
#
# Created by Aurélien Rainone
# github.com/aurelien-rainone/tmux-gitbar

load "../test_helper"

@test "there is a configuration file" {
  [ -f "$ROOTDIR/tmux-gitbar.conf" ]
}

