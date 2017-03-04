#!/usr/bin/env bash

# tmux-gitbar: Git in tmux status bar
#
# Created by Aurélien Rainone
# github.com/aurelien-rainone/tmux-gitbar

export MOCKREPO="${BATS_TMPDIR}/mock-repo"
export ROOTDIR="${BATS_TEST_DIRNAME}/../.."

create_test_repo() {
  backup_pwd

  # create the 'remote' repository
  git init -q --bare "${MOCKREPO}.git"

  # clone it and cd in the working tree
  git clone -q "${MOCKREPO}.git" "${MOCKREPO}"
  cd "${MOCKREPO}" || exit 1

  # set up fake user and email
  git config user.email "tmux@git.bar"
  git config user.name "Tmux-gitbar Tester"
  git config push.default simple

  # perform initial commit
  touch file1 file2 file3
  git add file1 file2 file3
  git commit -m 'commit 3 files'

  # set remote tracking and push
  git push --set-upstream origin master

  restore_pwd
}

cleanup_test_repo() {
  [ -d "${MOCKREPO}" ] && rm -rf "${MOCKREPO:?}"/
  [ -d "${MOCKREPO}.git" ] && rm -rf "${MOCKREPO}.git"/
}

backup_pwd() {
  pushd . > /dev/null
}

restore_pwd() {
  popd > /dev/null
}
