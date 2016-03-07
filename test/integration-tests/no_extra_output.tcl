#!/usr/bin/env expect

# Test description
#
#     This script tests that update-gitbar does not output nothing to stdout.
#      - running update-gitbar in PROMPT_COMMAND should obviously not produce
#        any output, even in case of error, as such output would be written 
#        into the user terminal before executing any command.
# How does this test works?
#
# - Set the PS1 env var to PROMPT so that it is easily recognizable.
# - run an *echo A* command on the terminal.
# - check the output produced on the terminal, it should only contain, in this
#   order:
#   - PROMPTecho A
#   - only CR or LF or ANSI escape sequences
#   - A (the one output by previous echo)
#   - only CR or LF or ANSI escape sequences
#   - PROMPT
# If this sequence is not matched that mean that some output has been produced
# and the text fails

source ./test/integration-tests/helpers/expect_setup.tcl

# Run tmux
spawn tmux -f $env(TMUXCONF)

# Wait for tmux to launch and attach
sleep 1
log_user 1

# Disable prompt and clear screen
send "PS1='PROMPT'"
sleep 0.5
clear_screen

send "echo A"

# ANSI control character sequence
set ansi {(?:[\x1b\x9b][[()#;?]*(?:[0-9]{1,4}(?:;[0-9]{0,4})*)?[0-9A-ORZcdf-nqry=><])*?}
set crlf {(?:\r\n)*}
set nonvisibles "(?:$crlf|$ansi)*"

set str "PROMPTecho A"
append str $nonvisibles
append str "A"
append str $nonvisibles
append str "PROMPT"

# As tmux started in-tree, expect to see the branch name
assert_on_screen_regex $str "No output should be produced by update-gitbar"

## End of test: success!
teardown_and_exit
