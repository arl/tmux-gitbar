# tmux-gitbar: git status in your tmux status bar
#
# Created by Aurélien Rainone
# github.com/aurelien-rainone/tmux-gitbar

# Additional keywords for tmux status string
readonly BRANCH_KWD="\#{git_branch}"
readonly REMOTE_KWD="\#{git_remote}"
readonly UPSTREAM_KWD="\#{git_upstream}"
readonly FLAGS_KWD="\#{git_flags}"

# Default symbols shown in status string. Can be redefined in tmux-gitbar.conf
NO_REMOTE_TRACKING_SYMBOL="L";
BRANCH_SYMBOL="⭠";
STAGED_SYMBOL="●"
CONFLICT_SYMBOL="✖"
CHANGED_SYMBOL="✚"
UNTRACKED_SYMBOL="…"
STASHED_SYMBOL="⚑"
CLEAN_SYMBOL="✔"
AHEAD_SYMBOL="↑·"
BEHIND_SYMBOL="↓·"
PREHASH_SYMBOL=":"

# Defaut Tmux format strings for Git bar components. Can be redefined in 
# tmux-gitbar.conf
BRANCH_FMT="#[fg=white]"
UPSTREAM_FMT="#[fg=cyan]"
REMOTE_FMT="#[fg=cyan]"
CLEAN_FMT="#[fg=green,bold]"
STAGED_FMT="#[fg=red,bold]"
CONFLICTS_FMT="#[fg=red,bold]"
CHANGED_FMT="#[fg=blue,bold]"
STASHED_FMT="#[fg=blue,bold]"
UNTRACKED_FMT="#[fg=magenta,bold]"
RESET_FMT="#[fg=default]"

# Load the config file. overwriting any redefined variables
readonly TMUX_GIT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
config_file="${TMUX_GIT_DIR}/tmux-gitbar.conf"
. "$config_file"

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

  # Create the 3 branch components
  branch="${BRANCH_FMT}${BRANCH_SYMBOL} ${git_branch}${RESET_FMT}"
  remote="${REMOTE_FMT}${git_remote}${RESET_FMT}"
  upstream="${UPSTREAM_FMT}${git_upstream}${RESET_FMT}"

  # Create the git flags components
  clean_flag=$(chk_gitvar 'clean' '-eq 1' "${CLEAN_FMT}${CLEAN_SYMBOL}${RESET_FMT} ")
  staged=$(chk_gitvar 'staged' '-ne 0' "${STAGED_FMT}${STAGED_SYMBOL} ${git_num_staged}${RESET_FMT} ")
  conflicts=$(chk_gitvar 'conflicts' '-ne 0' "${CONFLICTS_FMT}${CONFLICT_SYMBOL} ${git_num_conflicts}${RESET_FMT} ")
  changed=$(chk_gitvar 'changed' '-ne 0' "${CHANGED_FMT}${CHANGED_SYMBOL} ${git_num_changed}${RESET_FMT} ")
  stashed=$(chk_gitvar 'stashed' '-ne 0' "${STASHED_FMT}${STASHED_SYMBOL} ${git_num_stashed}${RESET_FMT} ")
  untracked=$(chk_gitvar 'untracked' '-ne 0' "${UNTRACKED_FMT}${UNTRACKED_SYMBOL} ${git_num_untracked}${RESET_FMT} ")
  dirty_flags=$(chk_gitvar 'clean' '-eq 0' "${staged}${conflicts}${changed}${stashed}${untracked} ")

  flags="| ${clean_flag}${dirty_flags}"

  # Put it all together
  local in="$1"
  local s1="${in/$BRANCH_KWD/$branch}"
  local s2="${s1/$REMOTE_KWD/$remote}"
  local s3="${s2/$UPSTREAM_KWD/$upstream}"
  local out="${s3/$FLAGS_KWD/$flags}"

  echo "$out"
}

# Update tmux git status bar, called within PROMPT_COMMAND
update_gitbar() {

  find_readlink

  # The trailing slash is for avoiding conflicts with repos with 
  # similar names. Kudos to https://github.com/tillt for the bug report
  CWD=$($_readlink "$(pwd)")/

  lastrepo_len=${#TMGB_LASTREPO}

  if [[ $TMGB_LASTREPO ]] && [ "$TMGB_LASTREPO" = "${CWD:0:$lastrepo_len}" ]; then
    git_repo="$TMGB_LASTREPO"

    read_git_info

    tmux set-window-option "status-$TMGB_STATUS_LOCATION-fg" "$TMGB_FG_COLOR" > /dev/null
    tmux set-window-option "status-$TMGB_STATUS_LOCATION-bg" "$TMGB_BG_COLOR" > /dev/null
    tmux set-window-option "status-$TMGB_STATUS_LOCATION-attr" bright > /dev/null
    tmux set-window-option "status-$TMGB_STATUS_LOCATION-length" 180 > /dev/null

    local status_string
    status_string=$(do_interpolation "${TMGB_STATUS_STRING}")
    tmux set-window-option "status-$TMGB_STATUS_LOCATION" "$status_string" > /dev/null

  else
    find_git_repo

    if [[ $git_repo ]]; then
      export TMGB_LASTREPO="$git_repo"
      update_gitbar
    else
      # Be sure to unset GIT_DIRTY's bright when leaving a repository.
      # Kudos to https://github.com/danarnold for the idea
      tmux set-window-option "status-$TMGB_STATUS_LOCATION-attr" none > /dev/null
      tmux set-window-option "status-$TMGB_STATUS_LOCATION-bg" "$TMGB_OUTREPO_BG_COLOR" > /dev/null
      tmux set-window-option "status-$TMGB_STATUS_LOCATION-fg" "$TMGB_OUTREPO_FG_COLOR" > /dev/null

      # Set the out-repo status
      tmux set-window-option "status-$TMGB_STATUS_LOCATION" "$TMGB_OUTREPO_STATUS" > /dev/null
    fi
  fi
}

# Update the prompt for execute the script
PROMPT_COMMAND="update_gitbar; $PROMPT_COMMAND"
