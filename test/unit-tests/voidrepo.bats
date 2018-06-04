#!/usr/bin/env bats

# tmux-gitbar: Git in tmux status bar
#
# Created by Aurélien Rainone
# github.com/aurelien-rainone/tmux-gitbar

load "../test_helper"
load "${ROOTDIR}/lib/tmux-gitbar.sh"
load "${ROOTDIR}/scripts/helpers.sh"

setup() {
  create_void_repo
  backup_pwd
}

@test "read branch name even for newly created repository" {
  cd "$MOCKREPO"
  find_git_repo 
  [ -n "$git_repo" ]

  run "${ROOTDIR}/scripts/gitstatus.sh" "$MOCKREPO"
  [ $status = 0 ]
  fields=($output)
  [ ${fields[0]} = 'master' ]
}

teardown() {
  restore_pwd
  cleanup_test_repo
}
