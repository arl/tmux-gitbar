#!/usr/bin/env bats

# tmux-gitbar: Git in tmux status bar
#
# Created by Aurélien Rainone
# github.com/aurelien-rainone/tmux-gitbar

load "../test_helper"
load "helpers/tmux_bats_helpers"

setup() {
  restore_tmgb_conf
  create_test_repo
  backup_pwd
}

# Covers both display modes of tmux-gitbar, in and out of a Git working tree,
# and how we switch form one to another
@test "behaviour in and out of git working tree" {
  set_option_in_tmux_conf 'status-right' '[out of working tree]'
  expect "${BATS_TEST_DIRNAME}/in_and_out_of_working_tree.tcl"
}

# Check the code relying on TMGB_STATUS_LOCATION works without side effects
@test "tmux-gitbar can show on the left" {

  set_tmgb_location_left
  set_option_in_tmux_conf 'status-left' '[out of working tree]'
  set_option_in_tmux_conf 'status-right' '[right]'
  expect -d "${BATS_TEST_DIRNAME}/tmux-gitbar_location.tcl" -- left
}

# Check the code relying on TMGB_STATUS_LOCATION works without side effects
@test "tmux-gitbar can show on the right" {

  # Default tmux-gitbar location is on the right
  set_option_in_tmux_conf 'status-right' '[out of working tree]'
  set_option_in_tmux_conf 'status-left' '[left]'
  expect "${BATS_TEST_DIRNAME}/tmux-gitbar_location.tcl" -- right
}

# Check that nothing is written on stdout/err during the execution of the 
# PROMPT_COMMAND. This could happen if a tmux command produces some error
# output (see issue #23 for example)
@test "PROMPT_COMMAND does not print nothing on terminal" {

  set_option_in_tmux_conf 'status' 'off'
  expect -d "${BATS_TEST_DIRNAME}/no_extra_output.tcl"
}

teardown() {
  restore_pwd
  cleanup_test_repo
  restore_tmgb_conf
}
