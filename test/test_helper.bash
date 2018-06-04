#!/usr/bin/env bash

# tmux-gitbar: Git in tmux status bar
#
# Created by Aurélien Rainone
# github.com/aurelien-rainone/tmux-gitbar

export MOCKREPO="${BATS_TMPDIR}/mock-repo"
export ROOTDIR="${BATS_TEST_DIRNAME}/../.."

create_test_repo() {

  working_tree="$MOCKREPO"
  repo="${working_tree}.git"

  backup_pwd

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

  restore_pwd
}

create_void_repo() {

  working_tree="$MOCKREPO"

  backup_pwd

  # create empty repository
  git init "$working_tree"

  restore_pwd
}


cleanup_test_repo() {

  working_tree="$MOCKREPO"
  repo="${working_tree}.git"

  if [ -d "$working_tree" ]; then rm -rf "$working_tree"/; fi
  if [ -d "$repo" ]; then rm -rf "$repo"/; fi
}

backup_pwd() {
  pushd . > /dev/null
}

restore_pwd() {
  popd > /dev/null
}
