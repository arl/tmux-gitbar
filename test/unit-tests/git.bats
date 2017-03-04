#!/usr/bin/env bats

# tmux-gitbar: Git in tmux status bar
#
# Created by Aurélien Rainone
# github.com/aurelien-rainone/tmux-gitbar

load "../test_helper"
load "${ROOTDIR}/lib/tmux-gitbar.sh"
load "${ROOTDIR}/scripts/helpers.sh"

setup() {
  create_mock_repo
  backup_pwd
}

teardown() {
  restore_pwd
  cleanup_test_repo
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
