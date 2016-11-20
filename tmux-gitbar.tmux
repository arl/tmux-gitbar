# tmux-gitbar: Git in tmux status bar
#
# Created by Aurélien Rainone
# github.com/aurelien-rainone/tmux-gitbar

# ensure TMUX_GITBAR_DIR is defined
if-shell 'test -z ${TMUX_GITBAR_DIR}' \
  'TMUX_GITBAR_DIR="$HOME/.tmux-gitbar"'

# ensure TMUX_GITBAR_CONF is defined
if-shell 'test -z ${TMUX_GITBAR_CONF}' \
  'TMUX_GITBAR_CONF="$HOME/.tmux-gitbar.conf"'

# generate configuration file if it doesn't exist
if-shell '! stat ${TMUX_GITBAR_CONF}' \
  'run-shell "$TMUX_GITBAR_DIR/lib/generate-config.sh $TMUX_GITBAR_CONF"'

# install update-gitbar as a prompt command if not done already
if-shell 'echo $PROMPT_COMMAND | grep -qv update-gitbar' \
  'PROMPT_COMMAND="$TMUX_GITBAR_DIR/update-gitbar; $PROMPT_COMMAND"'
