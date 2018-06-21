
[![Build status](https://travis-ci.org/arl/tmux-gitbar.svg?branch=master)](https://travis-ci.org/arl/tmux-gitbar)

Tmux-GitBar: shows Git Status in Tmux.
============

![tmux-gitbar demo](http://arl.github.io/tmux-gitbar/tmux-gitbar-demo.gif)

[**tmux-gitbar**][2] shows the status of your git working tree, right in
tmux status bar.

**Note** this project was initially on `github.com/aurelien-rainone/tmux-gitbar`, update
your remotes to `github.com/arl/tmux-gitbar`.

# Features

If the working directory is managed by Git, `tmux-gitbar` will present Git
status in a compact, discret and informative way, right in tmux status bar. When
the working directory is not managed by git, `tmux-gitbar` gets out of the way.

**Branches Info**
 - names of **local** and **remote** branches
 - number of commits before/after/divergent between them

**Working tree status**
 - is your working tree *clean*?
 - number of changed, stashed, untracked files
 - are there any conflicts?

Integrates **easily** and **discretely** with Tmux
 - status bar is left untouched if current directory in not managed by Git.
 - when it does show, `tmux-gitbar` doesn't overwrite anything, instead it
 places itself at the leftmost, or righmost end of the status bar.

**Customizable**  
`tmux-gitbar` has some sensible default, yet you can fully customize what
will be displayed, where and how, in `tmux-gitbar.conf`, this file is
auto-generated at first launch, in the installation directory.

<br>
<br><br>


# Table of Contents

* [Installation](#installation)
  * [Default installation](#default-installation)
  * [Installing to another location](#installing-to-another-location)
  * [Configuration file](#configuration-file)
  * [Font](#font)
* [Examples](#examples)
* [Documentation](#documentation)
  * [Status string](#status-string)
  * [tmux-gitbar keywords](#tmux-gitbar-keywords)
  * [Status bar location](#status-bar-location)
  * [Status bar color](#status-bar-color)
  * [Symbols](#symbols)
  * [Delimiters](#delimiters)
  * [Ignoring repositories](#ignoring-repositories)
* [Troubleshooting](#troubleshooting)
* [Credits](#credits)
* [License](#license)
* [Changelog](#changelog)


# Installation

You can install tmux-gitbar anywhere you want, by default the location is your
home directory.


## Default installation

Default installation directory is `$HOME/.tmux-gitbar`

**Get the code**

    git clone https://github.com/arl/tmux-gitbar.git ~/.tmux-gitbar

**Add this to `tmux.conf`**

    source-file "$HOME/.tmux-gitbar/tmux-gitbar.tmux"

That's it, next time you restart tmux and bash, **tmux-gitbar** will show when
the current directory is managed by Git.


## Choosing another install location

Let's say you prefer to install **tmux-gitbar** in
`/path/to/tmux-gitbar`.

**Get the code**

    git clone https://github.com/arl/tmux-gitbar.git /path/to/tmux-gitbar

**Add this to `tmux.conf`**

    TMUX_GITBAR_DIR="/path/to/tmux-gitbar"
    source-file "/path/to/tmux-gitbar/tmux-gitbar.tmux"

**Note:** `TMUX_GITBAR_DIR` environment variable **must be set** before sourcing
`tmux-gitbar.tmux`. It should not have any trailing slash.


## Configuration file

**tmux-gitbar** generates a default configuration file at first launch in
`$HOME/.tmux-gitbar.conf`. If you prefer having it somewhere else you should set
the new path in `$TMUX_GITBAR_CONF`.

**Add this to `tmux.conf`**

    TMUX_GITBAR_CONF="/path/to/.tmux-gitbar.conf"


## Font

The default `tmux-gitbar` configuration does not require you to install any
additional font. If however some symbols don't show up or are incorrectly
displayed, you should check that your terminal font supports the symbols used in
`tmux-gitbar`.

All default symbols can be replaced.

See the [Symbols](#symbols) or [Troubleshooting](#troubleshooting) sections for
more on this.

FYI, the font shown in the screenshots is [consolas-font-for-powerline][5], and
the default `BRANCH_SYMBOL` has been replaced.


# Examples

![tmux-gitbar demo](http://arl.github.io/tmux-gitbar/example1.png)
 - on branch master
 - remote tracking origin/master
 - local master is 1 commit ahead of origin/master
 - there is 1 changed (not staged) file
 - there is 1 untracked file

![tmux-gitbar demo](http://arl.github.io/tmux-gitbar/example2.png)
 - on branch master
 - remote tracking origin/master
 - local master is 1 commit ahead of origin/master
 - the working tree is clean

![tmux-gitbar demo](http://arl.github.io/tmux-gitbar/example3.png)
 - working tree is on a 'detached HEAD' state
 - no remote tracking branch
 - can't report about the remote branch
 - there is 1 staged file
 - there is 1 stash entry

![tmux-gitbar demo](http://arl.github.io/tmux-gitbar/example4.png)
 - on branch master
 - remote tracking origin/master
 - local master has diverged by 7 commits, origin/master by 1
 - there is one merge conflict


# Documentation

To cusstomize the location and appearance of `tmux-gitbar` you should see
`tmux-gitbar.conf`, this file is generated at first launch with the default
config.


## Status string

The status string takes care of the general appearance of the status bar,
each keyword corresponds to a specific information of the Git status.

Default status string is:

    TMGB_STATUS_STRING="#{git_branch} - #{git_upstream} - #{git_remote} #{git_flags}"


The status string can be made of any of the standard tmux keywords, plus 4 new
Git specific ones:

|     keyword     |     example    | definition 
|:---------------:|:--------------:|-------------
|`#{git_branch}`  |   `⭠ master`   | local branch
|`#{git_upstream}`| `origin/master`| remote tracking branch
|`#{git_remote}`  |     `↓n`       | local branch relative to upstream
|`#{git_flags}`   |  `●n ✚n` or `✔`| git status fields


## tmux-gitbar keywords

 * `#{git_branch}`

Shows the `⭠` symbol followed by the local branch name.

 * `#{git_upstream}`

Shows the name of remote _upstream_ branch or `^` if you are not tracking any
remote branch.

 * `#{git_remote}`

|symbol| meaning
|:----:|:------
| `↑n` | local branch is ahead of remote by n commits
| `↓n` | local branch is behind remote by n commits
|`↓m↑n`| local and remote branches have diverged, yours by m commits, remote by n
| `L`  | local branch only, not remotely tracked

 * `#{git_flags}`

|symbol|meaning
|------|-------
| `●n` | there are n staged files
| `✖n` | there are n files with merge conflicts
| `✚n` | there are n changed but unstaged files
| `…n` | there are n untracked files
| `⚑n` | there are n stash entries

Flags are not shown if value is 0.
The working tree is considered *clean* if all flags are 0, in this case a `✔`
is shown.


## Status bar location

Accepts `left` of `right`. Default:

    TMGB_STATUS_LOCATION=right


## Status bar color

 * `TMGB_BG_COLOR`

tmux-gitbar background color. Default is black.

 * `TMGB_FG_COLOR`

 tmux-gitbar foreground color. Default is white.


## Symbols

All symbols can be replaced. Symbols defined in `tmux-gitbar.conf` override
default ones.  For example, if you want to use the `x` to represent conflicts,
instead of the default '✖' (unicode `0x2716`), simply add to your `tmux-gitbar.conf`:

    CONFLICT_SYMBOL="x"


## Delimiters

Delimiters between various information can be customized:

 * `FLAGS_DELIMITER_FMT` delimits the different status flags
 * `SYMBOL_DELIMITER_FMT` delimits the a status flag symbol with the
    corresponding number
 * `SPLIT_DELIMITER_FMT` delimits the status flags with the rest of the status
    string.


## Ignoring Repositories

You can ignore a repository by adding the file `.tmgbignore` to the root of the
repository to be ignored. This will stop tmux-gitbar from showing for the
targeted repository.

    touch "/path/to/repo/.tmgbignore"


# Troubleshooting

## tmux-gitbar doesn't show up entirely...

It may simply be hidden because there isn't enough remaining space on the
status bar. Try to increase the length of tmux status bar (left or or right)
and/or remove some information from the tmux status bar (in `tmux.conf`):

```bash
# increase space on right status bar
set -g status-right-length 100

# remove everything on the right (just tmux-gitbar will show up)
set -g status-right ""
```
By default tmux-gitbar shows on the right, set `left` in `tmux-gitbar.conf` to
see if that is your case (in `tmux-gitbar.conf`).


## nothing is showing on tmux status bar...

### Check if your `$PROMPT_COMMAND` has been overwritten.

To check this, open a tmux session and run:

    /path/to/tmux-gitbar/update-gitbar

If tmux-gitbar shows up, that means something (in your `.bashrc`?) might be
overwriting the `$PROMPT_COMMAND` environment variable installed by tmux-gitbar.
`$PROMPT_COMMAND` should be a concatenation of commands, as `$PATH` is a
concatenation of paths.


### Check if your `$PROMPT_COMMAND` has been overwritten (2).

To check this, open a tmux session and run:

    echo $PROMPT_COMMAND

If the output is `__vte_prompt_command` and only `__vte_prompt_command`, try
to change or set `default-terminal` in your tmux configuration file (probably
located at `~/.tmux.conf`):

    set -g default-terminal "screen-256color"

This is a known issue, on various Linux distributions, of a script that comes
with certain versions of `libvte`. It overwrites the user `$PROMPT_COMMAND`
environment variable instead of concatenating to it. There are different
workarounds, the easiest being not to set `default-terminal` to a string
containing `xterm` nor `vte`, for example `screen-256color`.


## Windows Subsystem for Linux

Some users reported some symbols do not show up correctly with Bash on Windows,
even when some additional font has been installed. Replace the offending symbols
to solve this, see [Symbols](#symbols) and #49.


## [file an issue](https://github.com/arl/tmux-gitbar/issues/new)

Try to provide a maximum of context, at least:
 - the output of `tmux -V && echo $SHELL`
 - if possible, the content of your `.tmux.conf`
 - the output of `echo $PROMPT_COMMAND` while inside a tmux session.

Thanks!


# Credits

The inspiration for and a part of the code base of **tmux-gitbar** are coming
from those 2 great projects:
 - [bash-git-prompt][3] an informative and fancy bash prompt for Git users.
 - [tmux-git][4] a script for showing current Git branch in Tmux status bar

Contributers:
 - [AlexKornitzer][7]
 - [roobert][8]

Other credits for :
 - [tmux/tmux][1]
 - [gh-md-toc][6]


# License

**tmux-gitbar** is licensed under GNU GPLv3.


# Changelog

### v2.1.5, 2018-06-21
- fix #57: git status still read when `.tmgbignore` found

### v2.1.4, 2018-06-04
- fix #54: garbage output on newly created repositories.

### v2.1.3, 2017-04-28
- update README: libvte workaround (troubleshooting)

### v2.1.2, 2017-04-14
- allow configuring status bar delimiters

### v2.1.1, 2016-11-23
- add support for ignoring repositories through `.tmgbignore`

### v2.1.0, 2016-11-20
- configuration file location is defined by `$TMUX_GITBAR_CONF`
- Fix issue 37: tmux-gitbar.conf can be stored outside of repo.

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
[2]: https://github.com/arl/tmux-gitbar
[3]: https://github.com/magicmonty/bash-git-prompt
[4]: https://github.com/drmad/tmux-git
[5]: https://github.com/runsisi/consolas-font-for-powerline
[6]: https://github.com/ekalinin/github-markdown-toc
[7]: https://github.com/AlexKornitzer
[8]: https://github.com/roobert

