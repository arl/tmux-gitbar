# tmux-gitbar: Git in tmux status bar
#
# Created by Aurélien Rainone
# github.com/aurelien-rainone/tmux-gitbar

is_osx() {
  [ $(uname) == "Darwin" ]
}

find_readlink() {

  if is_osx; then
    _readlink='greadlink -e'
  else
    _readlink='readlink -e'
  fi
}


