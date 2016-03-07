# expect setup

source ./test/integration-tests/helpers/expect_helpers.tcl
source ./test/integration-tests/helpers/tmux_helpers.tcl
expect_setup

# exit status global var is successful by default
set exit_status 0
