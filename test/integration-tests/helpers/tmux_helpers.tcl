# tmux functions for expect scripts

proc kill_tmux_server {} {
  send "tmux kill-server\r"
  sleep 0.2
}

proc tmux_set_option {key value} {
  set cmd "tmux set-option \"$key\" \"$value\""
  send "$cmd"
}

