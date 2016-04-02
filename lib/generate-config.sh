#!/usr/bin/env bash
#
# tmux-gitbar: Git in tmux status bar
#
# Created by Aurélien Rainone
# github.com/aurelien-rainone/tmux-gitbar

print_config() {

  cat <<EOF
# tmux-gitbar: Git in tmux status bar
#
# Created by Aurélien Rainone
# github.com/aurelien-rainone/tmux-gitbar

#
# This is the tmux-gitbar configuration file
#

# Location of the status on tmux bar: left or right
readonly TMGB_STATUS_LOCATION='right'

# Style for tmux-gitbar
readonly TMGB_STYLE='bg=black,fg=white,bright'

# Status line format string definition.
# It controls what tmux-gitbar will show in the status line. It accepts
# any keyword or variable Tmux originally accepts, plus these ones:
#
# - #{git_branch}   : local branch name
# - #{git_remote}   : remote tracking branch
# - #{git_upstream} : upstream branch info
# - #{git_flags}    : working tree status flags
#
# See README.md for additional information
readonly TMGB_STATUS_STRING=" #{git_branch} - #{git_upstream} - #{git_remote} #{git_flags}"
EOF
}

main() {
  tmgbconf="${1}"
  if print_config > "${tmgbconf}" ; then
    echo "Generated tmux-gitbar configuration..."
  else
    echo "Couldn't generate tmux-gitbar configuration"
  fi
}

main "$@"
