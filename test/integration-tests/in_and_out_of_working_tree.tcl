#!/usr/bin/env expect -d

source ./test/integration-tests/helpers/expect_setup.tcl

set mockrepo $env(MOCKREPO)

# move into our mock repo directory
cd $mockrepo

# Run tmux
spawn tmux -f $env(TMUXCONF)

# Wait for tmux to launch and attach
sleep 1

# tmux is started inside a git-tree directory, so we expect the status bar to
# be composed of the 'normal' tmux status, followed by the branch name
assert_on_screen_regex "status.*origin/master" "should show previous status + git status"

# Goes out of tree, 'normal' status should show without the branch name
send_cd /
assert_on_screen "status" "should show normal status string"
assert_not_on_screen "origin/master" "should not show git status"

# Turn back into the git working tree
send_cd $mockrepo
assert_on_screen_regex "status.*origin/master" "should show normal status + git branch"

# End of test: success!
teardown_and_exit
