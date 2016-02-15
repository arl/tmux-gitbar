# tmux-git
# Script for showing current Git branch in Tmux status bar
#
# Created by Oliver Etchebarne - http://drmad.org/ with contributions
# from many github users. Thank you all.

TMUX_GIT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load the config file.
config_file="${TMUX_GIT_DIR}/tmux-git.conf"
. "$config_file"

# Symbols shown in status string
readonly NO_REMOTE_TRACKING_SYMBOL="L";
readonly BRANCH_SYMBOL="⭠";
readonly STAGED_SYMBOL="●"
readonly CONFLICT_SYMBOL="✖"
readonly CHANGED_SYMBOL="✚"
readonly UNTRACKED_SYMBOL="…"
readonly STASHED_SYMBOL="⚑"
readonly CLEAN_SYMBOL="✔"
readonly AHEAD_SYMBOL="↑·"
readonly BEHIND_SYMBOL="↓·"
readonly PREHASH_SYMBOL=":"

# Additional keywords for tmux status string
readonly BRANCH_KWD="\#{git_branch}"
readonly REMOTE_KWD="\#{git_remote}"
readonly UPSTREAM_KWD="\#{git_upstream}"
readonly FLAGS_KWD="\#{git_flags}"
readonly CLEAN_KWD="\#{git_clean}"

# Tmux format strings for specific git vars
readonly BRANCH_FMT="#[fg=white]"
readonly UPSTREAM_FMT="#[fg=cyan]"
readonly REMOTE_FMT="#[fg=cyan]"
readonly CLEAN_FMT="#[fg=green,bold]"
readonly STAGED_FMT="#[fg=red,bold]"
readonly CONFLICTS_FMT="#[fg=red,bold]"
readonly CHANGED_FMT="#[fg=blue,bold]"
readonly STASHED_FMT="#[fg=blue,bold]"
readonly UNTRACKED_FMT="#[fg=magenta,bold]"
readonly RESET_FMT="#[fg=default]"


# Use a different readlink according the OS.
# Kudos to https://github.com/npauzenga for the PR
find_readlink() {

  if [[ "$(uname)" = 'Darwin' ]]; then
    _readlink='greadlink -e'
  else
    _readlink='readlink -e'
  fi
}

# Looks upwards from the current directory to find a git repository
# Adapted from http://aaroncrane.co.uk/2009/03/git_branch_prompt/
find_git_repo() {

  local dir=.
  until [ "$dir" -ef / ]; do
    if [ -f "$dir/.git/HEAD" ]; then
      git_repo=$($_readlink $dir)/
      return
    fi
    dir="../$dir"
  done
  git_repo=''
  return
}

replace_branch_symbols() {

  local s1; local s2; local s3
  s1="${1//_AHEAD_/${AHEAD_SYMBOL}}"
  s2="${s1//_BEHIND_/${BEHIND_SYMBOL}}"
  s3="${s2//_NO_REMOTE_TRACKING_/${NO_REMOTE_TRACKING_SYMBOL}}"

  echo "${s3//_PREHASH_/${PREHASH_SYMBOL}}"
}

# Read git variables
read_git_info() {

  # Trick to read active pane's current directory
  # Kudos to http://superuser.com/questions/911870
  export __GIT_STATUS_CWD=$(tmux display-message -p -F "#{pane_current_path}")

  local -a git_status_fields
  git_status_fields=($("$TMUX_GIT_DIR/scripts/gitstatus.sh" 2>/dev/null))

  git_branch="$(replace_branch_symbols ${git_status_fields[0]})"
  git_remote="$(replace_branch_symbols ${git_status_fields[1]})"
  git_upstream="${git_status_fields[2]}"
  git_num_staged="${git_status_fields[3]}"
  git_num_conflicts="${git_status_fields[4]}"
  git_num_changed="${git_status_fields[5]}"
  git_num_untracked="${git_status_fields[6]}"
  git_num_stashed="${git_status_fields[7]}"
  git_clean="${git_status_fields[8]}"
}

# Perform keyword interpolation on STATUS_DEFINITION, defined in the
# configuration file
do_interpolation() {

  # chk_gitvar gitvar expr insert
  # eg: chk_gitvar  'staged' '-ne 0', 'STRING'
  # returns STRING if git_num_staged != 0 or ''
  chk_gitvar() {
    local v
    if [[ "x$2" == "x-n" ]] ; then
      v="$2 \"\$git_$1\""
    elif [[ "x$2" == x-eq* ]] ; then
      v="\$git_$1 $2"
    else
      v="\$git_num_$1 $2"
    fi
    if eval "test $v" ; then
      if [[ $# -lt 2 || "$3" != '-' ]]; then
        echo "${3}"
      else
        echo ""
      fi
    fi
  }

  # Create the 3 main components
  branch="${BRANCH_FMT}${BRANCH_SYMBOL} ${git_branch}${RESET_FMT}"
  remote="${REMOTE_FMT}${git_remote}${RESET_FMT}"
  upstream="${UPSTREAM_FMT}${git_upstream}${RESET_FMT}"

  # Create the 'clean repository' string
  clean=$(chk_gitvar 'clean' '-eq 1' "${CLEAN_FMT}${CLEAN_SYMBOL}${RESET_FMT} ")

  # Create the git vars string components
  staged=$(chk_gitvar 'staged' '-ne 0' "${STAGED_FMT}${STAGED_SYMBOL} ${git_num_staged}${RESET_FMT} ")
  conflicts=$(chk_gitvar 'conflicts' '-ne 0' "${CONFLICTS_FMT}${CONFLICT_SYMBOL} ${git_num_conflicts}${RESET_FMT} ")
  changed=$(chk_gitvar 'changed' '-ne 0' "${CHANGED_FMT}${CHANGED_SYMBOL} ${git_num_changed}${RESET_FMT} ")
  stashed=$(chk_gitvar 'stashed' '-ne 0' "${STASHED_FMT}${STASHED_SYMBOL} ${git_num_stashed}${RESET_FMT} ")
  untracked=$(chk_gitvar 'untracked' '-ne 0' "${UNTRACKED_FMT}${UNTRACKED_SYMBOL} ${git_num_untracked}${RESET_FMT} ")
  flags=$(chk_gitvar 'clean' '-eq 0' "| ${staged}${conflicts}${changed}${stashed}${untracked}${RESET_FMT} ")

  # Put it all together
  local in="$1"
  local s1="${in/$BRANCH_KWD/$branch}"
  local s2="${s1/$REMOTE_KWD/$remote}"
  local s3="${s2/$UPSTREAM_KWD/$upstream}"
  local s4="${s3/$FLAGS_KWD/$flags}"
  local out="${s4/$CLEAN_KWD/$clean}"

  echo "$out"
}

# Update tmux-gitstatus
update_tmgs() {

  find_readlink

  # The trailing slash is for avoiding conflicts with repos with 
  # similar names. Kudos to https://github.com/tillt for the bug report
  CWD=$($_readlink "$(pwd)")/

  lastrepo_len=${#TMGS_LASTREPO}

  if [[ $TMGS_LASTREPO ]] && [ "$TMGS_LASTREPO" = "${CWD:0:$lastrepo_len}" ]; then
    git_repo="$TMGS_LASTREPO"

    read_git_info

    tmux set-window-option "status-$TMUX_STATUS_LOCATION-attr" bright > /dev/null
    tmux set-window-option "status-$TMUX_STATUS_LOCATION-length" 180 > /dev/null

    local status_string
    status_string=$(do_interpolation "${STATUS_DEFINITION}")
    tmux set-window-option "status-$TMUX_STATUS_LOCATION" "$status_string" > /dev/null

  else
    find_git_repo

    if [[ $git_repo ]]; then
      export TMGS_LASTREPO="$git_repo"
      update_tmgs
    else
      # Be sure to unset GIT_DIRTY's bright when leaving a repository.
      # Kudos to https://github.com/danarnold for the idea
      tmux set-window-option "status-$TMUX_STATUS_LOCATION-attr" none > /dev/null

      # Set the out-repo status
      tmux set-window-option "status-$TMUX_STATUS_LOCATION" "$TMUX_OUTREPO_STATUS" > /dev/null
    fi
  fi
}

# Update the prompt for execute the script
PROMPT_COMMAND="update_tmgs; $PROMPT_COMMAND"
# vim: filetype=sh:tabstop=2:shiftwidth=2:expandtab
