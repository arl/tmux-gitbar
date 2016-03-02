# tmux-gitbar: Git in tmux status bar
#
# Created by Aurélien Rainone
# github.com/aurelien-rainone/tmux-gitbar

# install update-gitbar as a prompt command if not done already
if-shell 'echo $PROMPT_COMMAND | grep -qv update-gitbar' \
  "if-shell 'test -z \"${TMUX_GITBAR_DIR}\"' \
    'PROMPT_COMMAND=\"~/.tmux-gitbar/update-gitbar; $PROMPT_COMMAND\"' \
    'PROMPT_COMMAND=\"$TMUX_GITBAR_DIR/update-gitbar; $PROMPT_COMMAND\"'"
