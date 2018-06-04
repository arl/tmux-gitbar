#!/usr/bin/env bats

# tmux-gitbar: Git in tmux status bar
#
# Created by Aurélien Rainone
# github.com/aurelien-rainone/tmux-gitbar

load "../test_helper"
load "${ROOTDIR}/lib/tmux-gitbar.sh"
load "${ROOTDIR}/scripts/helpers.sh"

setup() {
  create_test_repo
  backup_pwd
}

@test "detect when in a git working tree" {
  cd "$MOCKREPO"
  find_git_repo 
  [ -n "$git_repo" ]
}

@test "detect toplevel dir of a git working tree" {
  cd "$MOCKREPO"
  mkdir not-top-level-dir > /dev/null
  cd not-top-level-dir > /dev/null
  find_git_repo
  [ "$git_repo" = "$MOCKREPO" ]
}

@test "detect when out of a git working tree" {
  cd /
  find_git_repo 
  [ -z "$git_repo" ]
}

@test "gitstatus fails when dir doesn't exist" {
  run "${ROOTDIR}/scripts/gitstatus.sh" "doesntexist"
  [ $status = 1 ]
}

teardown() {
  restore_pwd
  cleanup_test_repo
}
