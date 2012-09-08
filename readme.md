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

## Requirements

* Bash 3.2 or newer (Sorry, MINGW32 users)
* Ruby (for installation - I plan to remove this dependency)
* Homebrew (On OS X)
* git
* GNU Core Utilities

## Setup

### OS X

On OS X, Homebrew is presently required. (You almost certainly want it anyway)

* install [homebrew](http://github.com/mxcl/homebrew)
* `brew install coreutils --default-names`
* `brew install bash-completion`
* `brew install git`
* install [git-bash-completion](http://github.com/markgandolfo/git-bash-completion)

### Linux/Cygwin

* Coming Soon

### All Platforms

After completing the relevant platform-specific section,

* `git clone git@github.com:ticky/dotfiles.git ~/dotfiles`
* `cd ~/dotfiles && ruby install.rb`
* Restart your shell

## Todo

* Clean up PATH settings on different platforms
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
