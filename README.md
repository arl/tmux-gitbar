tmux-gitbar: git status in your tmux status bar
============

[**tmux-gitbar**][2] shows the status of your git working tree, in your [tmux][1] status bar.


# Overview

![tmux-gitbar demo](http://aurelien-rainone.github.io/tmux-gitbar/tmux-gitbar-demo.gif)

The idea of **tmux-gitbar** has been inspired by those 2 great projects:
* [bash-git-prompt][3] an informative and fancy bash prompt for Git users.
* [tmux-git][4] a script for showing current Git branch in Tmux status bar

[**tmux-gitbar**][2] combines both of them. It shows, right in your tmux status bar,
**all** the information you need about a git working tree, not only the current branch, and keeps your prompt intact.

# Installing

Get the code:

    git clone https://github.com/aurelien-rainone/tmux-gitbar.git

Add this to your `.bashrc` (or `.bash_profile`):

    if [[ $TMUX ]]; then source /path/to/tmux-gitbar/tmux-gitbar.sh; fi

If you do dotfiles, you can easily add **tmux-gitbar**, either directly or through a git submodule, like I did for [my dotfiles repo][5]. 

# Documentation

tmux-gitbar introduces some new keywords that can be added to `tmux
status-left` and `tmux-status-right` format definitions. See the Customizing
section for how to modify the symbols, colors and style of the information
shown in your status bar.

The default structure of the tmux-gitbar is:

    "#{git_clean} #{git_branch} - #{git_upstream} - #{git_remote} #{git_flags}"

## Status string keywords

### `#{git_clean}`

Expanded to ✔ if current working tree is *clean*.

### `#{git_branch}`

Shows the `⭠` symbol followed by the local branch name.

### `#{git_upstream}`

Informs about the 
 - The name of remote tracking branch.
 - or the `^` symbol if there's not remote tracking branch.

### `#{git_remote}`

Can either be:
 - ↑n: ahead of remote by n commits
 - ↓n: behind remote by n commits
 - ↓m↑n: branches diverged, other by m commits, yours by n commits
 - L: local branch, not remotely tracked

### `#{git_flags}`

The `#{git_flags}` keyword is expanded into a succession of fields, each representing a different piece of information about your git working tree:
 - ●n: there are n staged files
 - ✖n: there are n files with merge conflicts
 - ✚n: there are n changed but unstaged files
 - …n: there are n untracked files
 - ⚑n: there are n stash entries

The fields where the number would be 0 are ignored.  
**Note:**
If current working tree is *clean*, `#{git_flags}` is an empty string.


## Examples:

![tmux-gitbar demo](http://aurelien-rainone.github.io/tmux-gitbar/example1.png)
 - on branch master
 - remote tracking origin/master
 - local master is 1 commit ahead of origin/master
 - there is 1 changed but unstaged file
 - there is 1 untracked file

![tmux-gitbar demo](http://aurelien-rainone.github.io/tmux-gitbar/example2.png)
 - the working tree is clean
 - on branch master
 - remote tracking origin/master
 - local master and origin/master branches are even

![tmux-gitbar demo](http://aurelien-rainone.github.io/tmux-gitbar/example3.png)
 - working tree is on a 'detached HEAD' state
 - no remote tracking branch
 - can't report about the remote branch
 - there is 1 staged file
 - there is one stash entry

![tmux-gitbar demo](http://aurelien-rainone.github.io/tmux-gitbar/example4.png)
 - on branch master
 - remote tracking origin/master
 - local master and origin/master branches have diverged, remote from one commit, local by one commit.
 - there is one merge conflict


## Customizing the status bar

to be written...

# Credits

 - [tmux/tmux][1]
 - [magicmonty/bash-git-prompt][3]
 - [drmad/tmux-git][4]


# [License](LICENSE)

[1]: https://github.com/tmux/tmux
[2]: https://github.com/aurelien-rainone/tmux-gitbar
[3]: https://github.com/magicmonty/bash-git-prompt
[4]: https://github.com/drmad/tmux-git
[5]: https://github.com/aurelien-rainone/dotfiles

