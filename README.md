
[![Build status](https://travis-ci.org/aurelien-rainone/tmux-gitbar.svg?branch=master)](https://travis-ci.org/aurelien-rainone/tmux-gitbar)

tmux-gitbar: Git in tmux status bar
============

![tmux-gitbar
demo](http://aurelien-rainone.github.io/tmux-gitbar/tmux-gitbar-demo.gif)

[**tmux-gitbar**][2] shows the status of your git working tree, right in
tmux status bar.


# Features

Show **Local** and **Remote** Git branches information:
 - names of **local** and **remote** branches
 - divergence with upstream in number of commits

**Git Working tree status:**
 - immediately see if your working tree is *clean*
 - number of changed, stashed, untracked files
 - conflicts
 - stash
 - tmux-gitbar disappears when current directory is not a Git working tree

**Compatible** with other tmux **plugins**:
 - your tmux status bar remains unchanged when current directory is not part of
   a Git tree.
 - inside a Git tree, **tmux-gitbar** concatenates Git status to the tmux
   status bar. This is a new feature (since v2.0.0), so feel free to fill an
   issue, or even better, a pull-request, in case you discover any kind of
   incompatibility with a tmux plugin you are using.

**Customizable**  
You can customize the content and the style of the Git status bar, this is all
done in `tmux-gitbar.conf`, this file is auto-generated at first launch, in the
installation directory.

<br>
<br><br>


# Table of Contents

* [Installing](#installing)
  * [Installing to the default location](#installing-to-the-default-location)
  * [Installing to another location](#installing-to-another-location)
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
* [Changelog](#changelog)


# Installing

You can install tmux-gitbar anywhere you want, although it's slightly easier to
install it to the default location `$HOME/.tmux-gitbar`


## Installing to the default location

**Get the code**

```bash
git clone https://github.com/aurelien-rainone/tmux-gitbar.git ~/.tmux-gitbar
```

**Add this line to your `tmux.conf`**

```bash
source-file "$HOME/.tmux-gitbar/tmux-gitbar.tmux"
```

## Installing to another location

Let's say you prefer to install **tmux-gitbat** in
`/path/to/tmux-gitbar`.

**Get the code**

```bash
git clone https://github.com/aurelien-rainone/tmux-gitbar.git /path/to/tmux-gitbar
```

**Add those 2 lines to your `tmux.conf`**

```bash
TMUX_GITBAR_DIR="/path/to/tmux-gitbar"
source-file "/path/to/tmux-gitbar/tmux-gitbar.tmux"
```

**Important:** `TMUX_GITBAR_DIR` environment variable **must be set** before
sourcing `tmux-gitbar.tmux`.  
**Note:** Do not include the trailing slash.


## Font

The default tmux-gitbar configuration does not require you to install any
additional font. If your default NIX installation does not allow you to
visualize correctly the set of symbols, feel free to open an issue.

If you wish to change the appearance of tmux-gitbar by replacing one or more
symbols, have a look at the [Symbols section](#symbols) of this README.

FYI, the font used in the screenshots is [consolas-font-for-powerline][5], and
the default `BRANCH_SYMBOL has been replaced.


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

Customizing the location and appearance of tmux-gitbar is realized in 
`tmux-gitbar.conf`, this file is auto-generated at first launch if it doesn't
exist already.


## Status string

The status string is defined by assembling keywords. The set of possible
keywords is made of all the standard tmux keywords, plus 4 new git-specific
ones:

Default status string is:
```bash
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
```bash
TMGB_STATUS_LOCATION=right
```

## Status bar color

 * `TMGB_BG_COLOR`

tmux-gitbar background color. Default is black.

 * `TMGB_FG_COLOR`

 tmux-gitbar foreground color. Default is white.

## Symbols

You can replace the default symbols with others. Symbols defined in
`tmux-gitbar.conf` take precedence over the default ones.  
For example, if you want to use the `x` to represent conflicts, instead of the
default '✖' (unicode 0x2716), simply add to your `tmux-gitbar.conf`:

```bash
CONFLICT_SYMBOL="x"
```

# Credits

The inspiration for and a part of the code base of **tmux-gitbar** are coming
from those 2 great projects:
 - [bash-git-prompt][3] an informative and fancy bash prompt for Git users.
 - [tmux-git][4] a script for showing current Git branch in Tmux status bar

Other credits for :
 - [tmux/tmux][1]
 - [gh-md-toc][6]


# License

**tmux-gitbar** is licensed under GNU GPLv3.


# Changelog

### v2.0.0, 2016-08-29
- Concatenate Git status to previous status
- Fix issue 28: do not overwrite previous status

### v1.3.2, 2016-08-07
- Replace default BRANCH_SYMBOL with u8997 symbol
- Fix issue 10: some symbols do not render with the stock font

### v1.3.0, 2016-04-02
- `tmux-gitbar.conf` is not version controlled any more, and generated at first 
launch, allowing to update tmux-gitbar without overwriting user-customized
configuration.

### v1.2.0, 2016-03-26
- Add integration test suite

### v1.1.1, 2016-03-10
- Replace deprecated status-xxx-fg/bg/attr syntax with the new style syntax
- Fix issue 23 'bad colour' error

### v1.1.0, 2016-03-06
- Reorganize code to make testing easier
- Add unit testing
- Add travis continuous integration

### v1.0.3, 2016-03-02
- Protect from multiple prompt_command calls

### v1.0.2, 2016-02-29
- Fix Error on tmux.conf reload

### v1.0.1, 2016-02-25
- Remove vim modelines
- more portable shebangs

### v1.0.0, 2016-02-25
- **Breaking change**: no more need to modify `.bashrc`
- `PROMPT_COMMAND` now calls a script, not a shell function

### v0.1.0, 2016-02-25
- Include clean flags into `#{git_flags}` keyword
- Rework README, add screenshots, screencast

### v0.0.1, 2016-02-15
- Initial version

[1]: https://github.com/tmux/tmux
[2]: https://github.com/aurelien-rainone/tmux-gitbar
[3]: https://github.com/magicmonty/bash-git-prompt
[4]: https://github.com/drmad/tmux-git
[5]: https://github.com/runsisi/consolas-font-for-powerline
[6]: https://github.com/ekalinin/github-markdown-toc
