#!/usr/bin/env bash

# tmux-gitbar: Git in tmux status bar
#
# Created by Aurélien Rainone
# github.com/aurelien-rainone/tmux-gitbar

export MOCKREPO="${BATS_TMPDIR}/mock-repo"
export ROOTDIR="${BATS_TEST_DIRNAME}/.."

create_test_repo() {

  working_tree="$MOCKREPO"
  repo="${working_tree}.git"

  # create the repository
  git init -q --bare "$repo"

  # clone it, creating our working tree
  git clone -q "$repo" "$working_tree"
  cd "$working_tree"

  # fake user for git operations
  git config user.email "tmux@git.bar"
  git config user.name "Tmux-gitbar Tester"
  git config push.default simple

  # initial commit
  touch file1 file2 file3
  git add file1 file2 file3
  git commit -m 'commit 3 files'
  git push --set-upstream origin master
}

cleanup_test_repo() {

  working_tree="$MOCKREPO"
  repo="${working_tree}.git"

  [ -d "$working_tree" ] && rm -rf "$working_tree"/
  [ -d "$repo" ] && rm -rf "$repo"/
}
