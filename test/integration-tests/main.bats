#!/usr/bin/env bats

# tmux-gitbar: Git in tmux status bar
#
# Created by Aurélien Rainone
# github.com/aurelien-rainone/tmux-gitbar

load "../test_helper"
load "helpers/tmux_bats_helpers"

setup() {
  create_test_repo
  backup_pwd
}

# Covers both modes of tmux-gitbar, in and out of a Git working tree,
# and how we switch from one to another
@test "behaviour in and out of git working tree" {
  set_option_in_tmux_conf 'status-right' '#[fg=default,bg=default]status'
  expect "${BATS_TEST_DIRNAME}/in_and_out_of_working_tree.tcl"
}

# Check the code relying on TMGB_STATUS_LOCATION works without side effects
@test "tmux-gitbar can show on the left" {

  # Generate default tmgb conf, and change bar location
  gen_default_tmgb_conf
  set_tmgb_location_left

  set_option_in_tmux_conf 'status-left-length' 60
  set_option_in_tmux_conf 'status-left' 'left'
  set_option_in_tmux_conf 'status-right' 'right'
  expect -d "${BATS_TEST_DIRNAME}/tmux-gitbar_location.tcl" -- left
}

# Check the code relying on TMGB_STATUS_LOCATION works without side effects
@test "tmux-gitbar can show on the right" {

  # Default tmux-gitbar location is on the right
  gen_default_tmgb_conf

  set_option_in_tmux_conf 'status-right' 'right'
  set_option_in_tmux_conf 'status-left' 'left'
  expect "${BATS_TEST_DIRNAME}/tmux-gitbar_location.tcl" -- right
}

# Check that tmux-gitbar will detect .tmgbignore if present and hide
@test "tmux-gitbar can ignore repo" {
  set_option_in_tmux_conf 'status-right' '#[fg=default,bg=default]status'
  expect -d "${BATS_TEST_DIRNAME}/tmux-gitbar_ignore.tcl"
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
}
