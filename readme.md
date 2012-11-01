# Dotfiles

I like colors, a simple workflow and homebrew.  
If you do too, then you might like my dotfiles.

## Features

* colorful prompt, directories and git functions
* prompt updated with working git branch name and status
* autocomplete directories, history, commands and aliases
* useful aliases for git and more
* 2 line prompt for readability
* support for OS X, Linux and Cygwin
* built-in compatibility with both GNU utilities and BSD utilities

## Requirements

* Bash 3.2 or newer (Sorry, MINGW32 users)
* Ruby (for installation - I plan to remove this dependency)
* Homebrew (On OS X - This means you need Xcode installed first)
* git

## Setup

Setup involves a few steps specific to each platform, followed by the "all platforms" steps below.

### OS X

On OS X, Homebrew is presently required. (You almost certainly want it anyway)

* install [Xcode](https://itunes.apple.com/app/xcode/id497799835)
* install [homebrew](http://github.com/mxcl/homebrew)
* `brew install bash-completion`
* `brew install git`

### Linux

On Linux, you almost certainly have the core utilities needed. Just to be sure, you should install the following with your distro's package manager:

* bash-completion, git

### Cygwin

Cygwin has limited package management built-in. I recommend downloading [apt-cyg](http://code.google.com/p/apt-cyg/) which gives you a command-line interface for Cygwin's package manager.

* `apt-cyg install git`

### All Platforms

After completing the relevant platform-specific section,

* install [git-bash-completion](http://github.com/markgandolfo/git-bash-completion)
* `git clone git@github.com:ticky/dotfiles.git ~/dotfiles`
* `cd ~/dotfiles && ruby install.rb`
* Restart your shell

## Updating

There is no special method to updating. Simply pull any changes into your working copy and restart your shell.

## Platform-specific `bin` directories

This includes both a generalised `bin` directory for platform-agnostic scripts, and support for platform-specific directories. It's simple to use;

* run `uname` to determine the default name of the system - on OS X, this is `Darwin`, on Linux it varies.
* Create a directory under `~/dotfiles/bin` with the text output by `uname` (e.g. `~/dotfiles/bin/Darwin`)
* Place any platform-specific binaries in here

NOTE: I'm still playing around with this idea and the implementation is subject to change - if you have any ideas for how to do it better, let me know.

## Todo

* Create platform-specific bin directories

## Thanks

* [seaofclouds](http://github.com/seaofclouds)
* [ryan tomayko](http://tomayko.com/about)
* [pedro belo](http://github.com/pedro)
* [peter van hardenberg](http://github.com/pvh)
* james lindenbaum
* [chris wanstrath](http://ozmm.org/)
* google, blogs and probably you.

## Resources

* [Ryan Tomayko's Bash Profile](http://github.com/rtomayko/dotfiles)
* [No Duplicates in Bash History](http://www.thegeekstuff.com/2008/08/15-examples-to-master-linux-command-line-history/)
* [Cycle through history instead of listing](http://www.macosxhints.com/article.php?story=20050904022246573&lsrc=osxh)
* [IBM's bash prompt and color chart](http://www.ibm.com/developerworks/linux/library/l-tip-prompt/)
* [Dircolors](http://hocuspokus.net/2008/01/a-better-ls-for-mac-os-x)
* [mkdircd](http://www.thegeekstuff.com/2008/10/6-awesome-linux-cd-command-hacks-productivity-tip3-for-geeks/)
* [history grep alias](http://wuhrr.wordpress.com/2009/10/11/sweeten-bash-history-by-adding-grep/)
