#!/usr/bin/env bats
#
# tmux-gitbar: Git in tmux status bar
#
# Created by Aurélien Rainone
# github.com/aurelien-rainone/tmux-gitbar

load "../test_helper"
load "${ROOTDIR}/lib/tmux-gitbar.sh"
load "${ROOTDIR}/scripts/helpers.sh"

@test "readlink is available" {
  find_readlink
  [ -n "$_readlink" ]
}

@test "branch symbols are replaced" {
  branch_string='_PREHASH_1_NO_REMOTE_TRACKING_2_AHEAD_3_BEHIND_'
  AHEAD_SYMBOL='>'
  BEHIND_SYMBOL='<'
  NO_REMOTE_TRACKING_SYMBOL='^'
  PREHASH_SYMBOL='*'

  out=$(replace_branch_symbols "$branch_string")
  [ $out = "*1^2>3<" ]
}
