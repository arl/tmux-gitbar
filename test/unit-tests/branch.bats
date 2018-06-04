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

@test "read local branch name" {
  run "${ROOTDIR}/scripts/gitstatus.sh" "$MOCKREPO"
  [ $status = 0 ]
  fields=($output)
  [ ${fields[0]} = 'master' ]
}

@test "detect when local and remote branches are even" {
  run "${ROOTDIR}/scripts/gitstatus.sh" "$MOCKREPO"
  [ $status = 0 ]
  fields=($output)
  [ ${fields[1]} = '.' ]
}

@test "detect when local branch is behind remote" {
  cd "$MOCKREPO"
  git rm file1 && git commit -m 'Add file1'
  git push origin master
  git reset --hard HEAD~1
  run "${ROOTDIR}/scripts/gitstatus.sh" "$MOCKREPO"
  [ $status = 0 ]
  fields=($output)
  [ ${fields[1]} = '_BEHIND_1' ]
}

@test "detect when local branch is ahead of remote" {
  cd "$MOCKREPO"
  git rm file1 && git commit -m 'Add file1'
  run "${ROOTDIR}/scripts/gitstatus.sh" "$MOCKREPO"
  [ $status = 0 ]
  fields=($output)
  [ ${fields[1]} = '_AHEAD_1' ]
}

@test "read upstream branch name" {
  run "${ROOTDIR}/scripts/gitstatus.sh" "$MOCKREPO"
  [ $status = 0 ]
  fields=($output)
  [ ${fields[2]} = 'origin/master' ]
}

teardown() {
  restore_pwd
  cleanup_test_repo
}
