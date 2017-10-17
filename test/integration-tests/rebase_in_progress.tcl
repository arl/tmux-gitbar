#!/usr/bin/env expect -d

source ./test/integration-tests/helpers/expect_setup.tcl

set mockrepo $env(MOCKREPO)

# move into our mock repo directory
cd $mockrepo
# Run tmux
spawn tmux -f $env(TMUXCONF)

# Wait for tmux to launch and attach
sleep 1

# add something to file1
send "echo a > file1 && git add file1 && git commit -m 'add a'"
sleep 0.5
send "git push origin master"
sleep 0.5
send "git checkout -b branch-2 HEAD~1"
sleep 0.5

# in branch-2, add something else to file1
send "echo b > file1 && git add file1 && git commit -m 'add b'"
sleep 0.5

# trigger a conflict during rebase.
send "git rebase master"
sleep 0.5

# rebase-in-progress should be shown as tmux is started in a working tree in
# which a rebase is in progress.
assert_on_screen "rebase-in-progress" "should show rebase in progress"

# cancel rebasing and check rebase-in-progress is not shown anymore
send "git rebase --abort"
assert_not_on_screen "rebase-in-progress" "should show rebase in progress"

# End of test: success!
teardown_and_exit
