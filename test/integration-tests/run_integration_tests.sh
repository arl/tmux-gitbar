#!/usr/bin/env bash

export TMUXCONF="$PWD/tmux.conf"

# Create a minimal tmux conf file
> "${TMUXCONF}"
echo TMUX_GITBAR_DIR=\"$PWD\" >> "${TMUXCONF}"
echo source-file \"$PWD/tmux-gitbar.tmux\" >> "${TMUXCONF}"

bats test/integration-tests/main.bats
