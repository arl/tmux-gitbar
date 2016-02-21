tmux-gitbar: Git in tmux status bar
============

![tmux-gitbar
demo](http://aurelien-rainone.github.io/tmux-gitbar/tmux-gitbar-demo.gif)

[**tmux-gitbar**][2] shows the status of your git working tree, right in
tmux status bar.

# Features

Branches Information:
 - the names of **local** and **remote** branches
 - divergence with upstream in number of commits

Working tree status:
 - immediately see if your working tree is *clean*
 - number of changed, stashed, untracked files
 - conflicts
 - stash

# Table of Contents

 * [Installing](#installing)
   * [Font](#font)
 * [Examples](#examples)
 * [Documentation](#documentation)
   * [Status string](#status-string)
   * [tmux-gitbar keywords](#tmux-gitbar-keywords)
   * [Status bar location](#status-bar-location)
   * [Status bar color](#status-bar-color)
   * [Symbols](#symbols)
 * [Credits](#credits)
 * [License](#license)


# Installing

Get the code:

```console
git clone https://github.com/aurelien-rainone/tmux-gitbar.git
```

And add this to your `.bashrc`:

```console
if [[ $TMUX ]]; then source /path/to/tmux-gitbar/tmux-gitbar.sh; fi
```

## Font

If one or some symbols don't appear as they should or just if you'd
like to change them, have a look at the [Symbols section](#symbols) of this
README

FYI, the font used in the screenshots is [consolas-font-for-powerline][5].

# Examples

![tmux-gitbar demo](http://aurelien-rainone.github.io/tmux-gitbar/example1.png)
 - on branch master
 - remote tracking origin/master
 - local master is 1 commit ahead of origin/master
 - there is 1 changed (not staged) file
 - there is 1 untracked file

![tmux-gitbar demo](http://aurelien-rainone.github.io/tmux-gitbar/example2.png)
 - on branch master
 - remote tracking origin/master
 - local master is 1 commit ahead of origin/master
 - the working tree is clean

![tmux-gitbar demo](http://aurelien-rainone.github.io/tmux-gitbar/example3.png)
 - working tree is on a 'detached HEAD' state
 - no remote tracking branch
 - can't report about the remote branch
 - there is 1 staged file
 - there is 1 stash entry

![tmux-gitbar demo](http://aurelien-rainone.github.io/tmux-gitbar/example4.png)
 - on branch master
 - remote tracking origin/master
 - local master has diverged by 7 commits, origin/master by 1
 - there is one merge conflict


# Documentation

## Status string

The status string is defined by assembling keywords. The set of possible
keywords is made of all the standard tmux keywords, plus 4 new git-specific
ones:

Default status string is:
```console
TMGB_STATUS_STRING="#{git_branch} - #{git_upstream} - #{git_remote} #{git_flags}"
```

|keyword| example | definition |
|---|---|---|
|`#{git_branch}`|`⭠ master`| local branch |
|`#{git_upstream}`|`origin/master`|remote tracking branch|
|`#{git_remote}`|`↓n`|local status regarding remote|
|`#{git_flags}`|`●n ✚n` or `✔`| git status fields|

## tmux-gitbar keywords

 * `#{git_branch}`

Shows the `⭠` symbol followed by the local branch name.

 * `#{git_upstream}`

 Shows the name of remote tracking branch or `^` if you are not tracking any
 remote branch.

 * `#{git_remote}`

|symbol|meaning|
|---|---|
|`↑n`|local branch is ahead of remote by n commits|
|`↓n`|local branch is behind remote by n commits|
|`↓m↑n`|local and remote branches have diverged, yours by m commits, remote by n|
|`L`|local branch only, not remotely tracked|

 * `#{git_flags}`

|symbol|meaning|
|---|---|
|`●n`|there are n staged files|
|`✖n`|there are n files with merge conflicts|
|`✚n`|there are n changed but unstaged files|
|`…n`|there are n untracked files|
|`⚑n`|there are n stash entries|

Flags with number being 0 are not shown.  
The working tree is considered *clean* if all flags are 0, in this case a `✔`
is shown.


## Status bar location

Accepts `left` of `right`. Default:
```console
TMGB_STATUS_LOCATION=right
```

## Status bar color

 * `TMGB_BG_COLOR`

tmux-gitbar background color. Default is black.

 * `TMGB_FG_COLOR`

 tmux-gitbar foreground color. Default is white.


## Symbols

Default symbols are declared at the top of `tmux-gitbar.sh` and they can be
redefined in `tmux-gitbar.conf`.

# Credits

The inspiration for and a part of the code base of **tmux-gitbar** are coming from those 2 great projects:
 - [bash-git-prompt][3] an informative and fancy bash prompt for Git users.
 - [tmux-git][4] a script for showing current Git branch in Tmux status bar

Other credits for :
 - [tmux/tmux][1]
 - [gh-md-toc][6]

# License

**tmux-gitbar** is licensed under GNU GPLv3.

[1]: https://github.com/tmux/tmux
[2]: https://github.com/aurelien-rainone/tmux-gitbar
[3]: https://github.com/magicmonty/bash-git-prompt
[4]: https://github.com/drmad/tmux-git
[5]: https://github.com/runsisi/consolas-font-for-powerline
[6]: https://github.com/ekalinin/github-markdown-toc
