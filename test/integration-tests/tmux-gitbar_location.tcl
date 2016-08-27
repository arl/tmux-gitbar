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
    {left.*right.*origin/master} \
    "should show left, right and git statuses, in that order"

} elseif {$tmgb_loc == {left}} {

  assert_on_screen_regex \
    {left.*origin/master.*right} \
    "should show left, git and right statuses, in that order"
}

# Test gitbar location outside of git working tree
send_cd /

assert_on_screen_regex \
  {left.*right} \
  "should show left and right status strings"
assert_not_on_screen \
  "origin/master" \
  "should not show git status"

# End of test: success!
teardown_and_exit
