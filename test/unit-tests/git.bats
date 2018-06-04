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

@test "read number of staged files" {
  cd "$MOCKREPO"
  date > file1
  date > file2
  git add file1 file2
  run "${ROOTDIR}/scripts/gitstatus.sh" "$MOCKREPO"
  [ $status = 0 ]
  fields=($output)
  [ ${fields[3]} = 2 ]
}

@test "read number of conflicts" {
  cd "$MOCKREPO"
  echo a > file1 && git add file1 && git commit -m 'add a'
  git push origin master
  git checkout -b branch-2 HEAD~1
  echo b > file1 && git add file1 && git commit -m 'add b'
  run git merge master
  run "${ROOTDIR}/scripts/gitstatus.sh" "$MOCKREPO"
  [ $status = 0 ]
  fields=($output)
  [ ${fields[4]} = 1 ]
}

@test "read number of changed files" {
  cd "$MOCKREPO"
  date > file1
  date > file2
  run "${ROOTDIR}/scripts/gitstatus.sh" "$MOCKREPO"
  [ $status = 0 ]
  fields=($output)
  [ ${fields[5]} = 2 ]
}

@test "read number of untracked files" {
  cd "$MOCKREPO"
  touch untracked{1,2,3}
  run "${ROOTDIR}/scripts/gitstatus.sh" "$MOCKREPO"
  [ $status = 0 ]
  fields=($output)
  [ ${fields[6]} = 3 ]
}

@test "read number of elements in the stash" {
  cd "$MOCKREPO"
  date > file1 && git stash
  date > file2 && git stash
  run "${ROOTDIR}/scripts/gitstatus.sh" "$MOCKREPO"
  [ $status = 0 ]
  fields=($output)
  [ ${fields[7]} = 2 ]
}

@test "detect when working tree is clean" {
  cd "$MOCKREPO"
  run "${ROOTDIR}/scripts/gitstatus.sh" "$MOCKREPO"
  [ $status = 0 ]
  fields=($output)
  [ ${fields[8]} = 1 ]
}

@test "detect when working tree is dirty" {
  cd "$MOCKREPO"
  date > file1
  run "${ROOTDIR}/scripts/gitstatus.sh" "$MOCKREPO"
  [ $status = 0 ]
  fields=($output)
  [ ${fields[8]} = 0 ]
}

teardown() {
  restore_pwd
  cleanup_test_repo
}
