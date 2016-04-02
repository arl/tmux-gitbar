# tmux-gitbar: Git in tmux status bar
#
# Created by Aurélien Rainone
# github.com/aurelien-rainone/tmux-gitbar

# generate tmux-gitbar.conf if it doesn't exist
if-shell 'test -z ${TMUX_GITBAR_DIR}' \
  "if-shell '! stat ~/.tmux-gitbar/tmux-gitbar.conf' \
    'run-shell \"~/.tmux-gitbar/lib/generate-config.sh ~/.tmux-gitbar/tmux-gitbar.conf\"'" \
  "if-shell '! stat $TMUX_GITBAR_DIR/tmux-gitbar.conf' \
    'run-shell \"$TMUX_GITBAR_DIR/lib/generate-config.sh $TMUX_GITBAR_DIR/tmux-gitbar.conf\"'"

# install update-gitbar as a prompt command if not done already
if-shell 'echo $PROMPT_COMMAND | grep -qv update-gitbar' \
  "if-shell 'test -z \"${TMUX_GITBAR_DIR}\"' \
    'PROMPT_COMMAND=\"~/.tmux-gitbar/update-gitbar; $PROMPT_COMMAND\"' \
    'PROMPT_COMMAND=\"$TMUX_GITBAR_DIR/update-gitbar; $PROMPT_COMMAND\"'"
