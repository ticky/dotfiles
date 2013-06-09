# Dotfiles

I like colors, a simple workflow and homebrew.  
If you do too, then you might like my dotfiles.

## Features

* colorful prompt, directories and git functions
* prompt updated with working git branch name and status
* autocomplete directories, history, commands, common `killall` items and aliases
* useful aliases for git and more
* 2 line prompt for readability
* support for OS X, Linux and Cygwin (and exposes `$UNAME` environment variable containing a lower-case platform name)
* built-in compatibility with both GNU and BSD core utilities (also exposes `$COREUTILS` environment variable)
* useful user-level `.gitignore`
* sensible `screen` setup - no startup message, real bells and your user shell
* support for `tmux` (very basic for now)
* good `wget` defaults

## Requirements

* **`git`**  
  _...Welcome to GitHub_
* **Bash 3.2** or newer  
  _Sorry, MinGW users_
* **Python**  
  _Optional, only used for the `shttp` shortcut, which starts an HTTP server for the current directory_
* **Homebrew**  
  _OS X Only - This means you need Xcode installed first_
* **`ncurses `**  
  _If this isn't installed, the `clear` command is missing_
* **DejaVu Sans Mono**  
  _Cygwin Only - I use this font in MinTTY, and it'll fall back to Courier if it's not installed_

## Setup

Setup involves a few steps specific to each platform, followed by the "all platforms" steps below.

### OS X

On OS X, Homebrew is presently required. (You almost certainly want it anyway)

* install [Xcode](https://itunes.apple.com/app/xcode/id497799835)
* install [Homebrew](http://github.com/mxcl/homebrew)
* `brew install bash-completion`
* `brew install git`

### Linux

On Linux, you almost certainly have the core utilities needed. Just to be sure, you should install the following with your distro's package manager:

* bash-completion, git

### Cygwin

Cygwin has limited package management built-in. I recommend downloading [apt-cyg](http://code.google.com/p/apt-cyg/) which gives you a command-line interface for Cygwin's package manager.

* `apt-cyg install openssh git`

### All Platforms

After completing the relevant platform-specific section,

* install [git-bash-completion](http://github.com/markgandolfo/git-bash-completion)
* `git clone https://github.com/geoffstokes/dotfiles.git ~/dotfiles`
* `~/dotfiles/install.sh`  
  _**NOTE**: If `install.sh` detects that dependencies are missing, it will notify you and abort._
* if on OS X, run `osxdefaults.sh` to set OS X defaults  
  _**TODO**: streamline this into the setup process)_
* Restart your shell

## Updating

* pull changes into your local copy
* run `~/dotfiles/install.sh`

In short (if you haven't changed anything locally), `cd ~/dotfiles && git pull && profile install`

_**NOTE**: OS X defaults will not be updated on shell restarts. They are only updated when you explicitly run `osxdefaults.sh`_

## Platform-specific directories

This supports two kinds of platform-specific functionality;

1. Platform-specific `bin` directories
2. Platform-specific `~` includes

The install script will manage this automatically. You can find these under `dotfiles/platforms`.

* Files in `dotfiles/platforms/{platform}/bin` are automatically available in your `$PATH`.

* Files in `dotfiles/platforms/{platform}/home` are either symlinked (editing `~/{file}` updates `dotfiles/platforms/{platform}/file` - platform-specific includes are only possible if the file is executable) or concatenated (appended; this allows platform-specific stuff to be added to files which aren't executed).

This setup includes a helper function for this called `platformbindir`. Running this will;
* create the platform-specific `bin` directory if it doesn't already exist
* output the full location of the platform-specific `bin` directory

So it's easy to add stuff; you can do stuff like ``cd `platformbindir` ``, which navigates straight to the current platform's `bin` directory.

_**NOTE**: Due to the way this works, it's not possible to update a concatenated file in your home directory and commit it immediately. You will need to make the edit twice for those files._

## Thanks

* [seaofclouds](http://github.com/seaofclouds)
* [mathias bynens](http://mths.be/)
* [ryan tomayko](http://tomayko.com/about)
* [pedro belo](http://github.com/pedro)
* [peter van hardenberg](http://github.com/pvh)
* james lindenbaum
* [chris wanstrath](http://ozmm.org/)
* google, blogs and probably you.

## Resources

* [GitHub does dotfiles](http://dotfiles.github.com/)
* [Mathias Bynens' Dotfiles](http://mths.be/dotfiles)
* [Ryan Tomayko's Bash Profile](http://github.com/rtomayko/dotfiles)
* [No Duplicates in Bash History](http://www.thegeekstuff.com/2008/08/15-examples-to-master-linux-command-line-history/)
* [Cycle through history instead of listing](http://www.macosxhints.com/article.php?story=20050904022246573&lsrc=osxh)
* [IBM's bash prompt and color chart](http://www.ibm.com/developerworks/linux/library/l-tip-prompt/)
* [Dircolors](http://hocuspokus.net/2008/01/a-better-ls-for-mac-os-x)
* [mkdircd](http://www.thegeekstuff.com/2008/10/6-awesome-linux-cd-command-hacks-productivity-tip3-for-geeks/)
* [history grep alias](http://wuhrr.wordpress.com/2009/10/11/sweeten-bash-history-by-adding-grep/)
