# general functions for expect scripts

# basic setup for each script
proc expect_setup {} {
  # disables script output
  log_user 0
  # standard timeout
  set timeout 2
}

proc exit_status_false {} {
  global exit_status
  set exit_status 1
}

proc send_cd {dir} {
  send "cd $dir\r"
  sleep 0.5
}

proc teardown_and_exit {} {
  global exit_status
  kill_tmux_server
  exit $exit_status
}

proc clear_screen {} {
  send ""
  sleep 0.5
}

proc assert_on_screen {text message} {
  expect {
    "$text" {
      puts "  Success: $message"
    }
    timeout {
      puts "  Fail: $message"
      exit_status_false
    }
  }
}

proc assert_not_on_screen {text message} {
  expect {
    "$text" {
      puts "  Fail: $message"
      exit_status_false
    }
    timeout {
      puts "  Success: $message"
    }
  }
}

proc assert_on_screen_regex {text message} {
  expect {
    -re "$text" {
      puts "  Success: $message"
    }
    timeout {
      puts "  Fail: $message"
      exit_status_false
    }
  }
}

proc assert_colored {text color} {
  # TODO: to implement
  puts "To IMPLEMENT"
}

proc assert_style {text color} {
  # TODO: to implement
  # PRENDRE EXAMPLE DANS tmux-copycat, assert_highlighted
  puts "To IMPLEMENT"
}

