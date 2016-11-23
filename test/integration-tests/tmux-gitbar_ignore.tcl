#!/usr/bin/env expect -d

source ./test/integration-tests/helpers/expect_setup.tcl

set mockrepo $env(MOCKREPO)

# Move into our mock repo directory
cd $mockrepo

# Run tmux
spawn tmux -f $env(TMUXCONF)

# Wait for tmux to launch and attach
sleep 1

# tmux is started inside a git-tree directory, so we expect the status bar to
# be composed of the 'normal' tmux status, followed by the branch name
assert_on_screen_regex "status.*origin/master" "should show previous status + git status"

# Create the ignore file
set fp [ open ".tmgbignore" w]
close $fp

# tmux status line should be empty inside and outside the repo
send_cd $mockrepo
assert_on_screen "status" "should show normal status string"
assert_not_on_screen "origin/master" "should not show git status"
send_cd /
assert_on_screen "status" "should show normal status string"
assert_not_on_screen "origin/master" "should not show git status"
send_cd $mockrepo
assert_on_screen "status" "should show normal status string"
assert_not_on_screen "origin/master" "should not show git status"

# Delete ignore file and check for status
file delete ".tmgbignore"
send_cd $mockrepo
assert_on_screen_regex "status.*origin/master" "should show normal status + git branch"

# End of test: success!
teardown_and_exit
