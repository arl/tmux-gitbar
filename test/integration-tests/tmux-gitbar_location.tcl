#!/usr/bin/env expect -d

source ./test/integration-tests/helpers/expect_setup.tcl

set mockrepo $env(MOCKREPO)
set tmgb_loc [lindex $argv 0]

# move into our mock repo directory
cd $mockrepo

# Run tmux
spawn tmux -f $env(TMUXCONF)

# Wait for tmux to launch and attach
sleep 1

# Test gitbar location when inside a git working tree
if {$tmgb_loc == {right}} {

  assert_on_screen_regex \
    {left.*origin/master} \
    "branch name should show on the right"

} elseif {$tmgb_loc == {left}} {

  assert_on_screen_regex \
    {origin/master.*right} \
    "branch name should show on the left"
}

# Test gitbar location outside of git working tree
send_cd /
if {$tmgb_loc == {right}} {

  assert_on_screen_regex \
    {left.*out of working tree} \
    "out of repo status string should show on the right"

} elseif {$tmgb_loc == {left}} {

  assert_on_screen_regex \
    {out of working tree.*right} \
    "out of repo status string should show on the left"
}

# End of test: success!
teardown_and_exit
