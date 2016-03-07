#!/usr/bin/env expect -d

source ./test/integration-tests/helpers/expect_setup.tcl

set mockrepo $env(MOCKREPO)

# move into our mock repo directory
cd $mockrepo

# Run tmux
spawn tmux -f $env(TMUXCONF)

# Wait for tmux to launch and attach
sleep 1

# As tmux started in-tree, expect to see the branch name
assert_on_screen "origin/master" "should show git branch name"

# Goes out of tree
send_cd /
assert_on_screen "out of working tree" "should show out-of-tree status string"

# Turn back into the git working tree
send_cd $mockrepo
assert_on_screen "origin/master" "should show git branch name"

# End of test: success!
teardown_and_exit
