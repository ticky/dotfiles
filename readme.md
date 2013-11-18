# Dotfiles

I like colours, a simple workflow and homebrew.  
If you do too, then you might like my dotfiles.

## Features

* colorful prompt, directories and git functions in both `bash` and `zsh`
* prompt updated with working `git` branch name and status
* autocomplete directories, history, commands, common `killall` items and aliases
* 2 line prompt for readability
* support for OS X, Linux and Cygwin (and exposes `$UNAME` environment variable containing a lower-case platform name)
* built-in compatibility with both GNU and BSD core utilities
* useful aliases for git and more
* support for the [hub](https://github.com/defunkt/hub) git extension
* useful user-level `.gitignore`
* stops `play` from spawning a useless dock icon and stealing focus for no reason
* imports `rvm` by default
* sensible `screen` setup - no startup message, real bells and your user shell
* support for `tmux` (very basic for now, on all platforms but Cygwin)
* good `wget` defaults

## Requirements

* `git`  
  _...Welcome to GitHub_
* **Python 2.6/2.7**  
  _Optional, only used for the `shttp` shortcut, which starts an HTTP server for the current directory_
* **Homebrew**  
  _OS X Only - This means you need Xcode installed first_
* `ncurses`  
  _If this isn't installed, the `clear` command is missing_
* **DejaVu Sans Mono**  
  _Cygwin Only - I use this font in MinTTY, and it'll fall back to Courier if it's not installed_

_**On Windows?** I'm attempting to improve the Windows command prompt in similar ways, over at [batfiles](https://github.com/geoffstokes/batfiles)._

### Supported Shells
* **zsh 4.3** or newer  
  _This is not a hard requirement, however, this version is the one supplied with OS X 10.8_
* **Bash 3.2** or newer  
  _Sorry, MinGW users_

The focus of future updates to these dotfiles will be zsh. At some point, bash support may be removed, but only once the environments I use consistently have a compatible zsh version available.

## Setup

Setup involves a few steps specific to each platform, followed by the "all platforms" steps below.

### OS X

On OS X, Homebrew is presently required. (You almost certainly want it anyway)

* install [Xcode](https://itunes.apple.com/app/xcode/id497799835)
* install [Homebrew](http://github.com/mxcl/homebrew)
* `brew install bash-completion`
* `brew install git`

### Cygwin

Cygwin has limited package management built-in. I recommend downloading [apt-cyg](http://code.google.com/p/apt-cyg/) which gives you a command-line interface for Cygwin's package manager.

* `apt-cyg install openssh git`

### Linux

On Linux, you almost certainly have the core utilities needed. Just to be sure, you should install the following with your distro's package manager:

* `bash-completion`, `git`

### All Platforms

After completing the relevant platform-specific section,

* install [git-bash-completion](http://github.com/markgandolfo/git-bash-completion)
* `git clone https://github.com/geoffstokes/dotfiles.git ~/dotfiles`
* `~/dotfiles/install.sh`  
  _**NOTE**: If `install.sh` detects that dependencies are missing, it will notify you and abort._
* if on OS X, run `osxdefaults` to set OS X defaults  
  _**TODO**: streamline this into the setup process_
* Restart your shell

## Updating

* pull changes into your local copy
* run `~/dotfiles/install.sh`

In short (if you haven't changed anything locally), `cd ~/dotfiles && git pull && profile install`

_**NOTE**: OS X defaults will not be updated on shell restarts. They are only updated when you explicitly run `osxdefaults` (and are, naturally, only available on OS X)_

## Platform-specific directories

### Single-Platform

This supports three kinds of platform-specific functionality;

1. Platform-specific `bin` directories
2. Platform-specific `~` includes
3. Platform-specific `zshrc` includes

The install script will manage this automatically. You can find these under `dotfiles/platforms`.

* Files in `dotfiles/platforms/{platform}/bin` are automatically available in your `$PATH`.

* Files in `dotfiles/platforms/{platform}/home` are either symlinked (editing `~/{file}` updates `dotfiles/platforms/{platform}/file` - platform-specific includes are only possible if the file is executable) or concatenated (appended; this allows platform-specific stuff to be added to files which aren't executed).

* Files in `dotfiles/platforms/{platform}/zsh` are loaded by `.zshrc` (and thus, only when running `zsh`), in the following order;
	1. `path.zsh` - settings for `$PATH` go here
	2. All files except `path.zsh` and `completion.zsh`, in alphabetical order - general settings and custom categorisation goes here
	3. `completion.zsh` - completion settings go here

This setup includes a helper function for this called `platformbindir`. Running this will;
* create the platform-specific `bin` directory if it doesn't already exist
* output the full location of the platform-specific `bin` directory

So it's easy to add stuff; you can do stuff like ``cd `platformbindir` ``, which navigates straight to the current platform's `bin` directory.

_**NOTE**: Due to the way this works, it's not possible to update a concatenated file in your home directory and commit it immediately. You will need to make the edit twice for those files._

### All-But-Platform

Additionally, there is provision for such directories usable for all but a certain platform. For example, `tmux` works anywhere except on Cygwin, so `tmux.conf.concat` is placed in `dotfiles/platforms/all-but-cygwin/home`. It then applies on `linux` and `darwin`, but not `cygwin`.

There are no shortcuts for configuring this, however, it relies on the same `$UNAME` variable as the above, so if you had a `linux` directory, the all-but directory is `all-but-linux`.

## Shortcuts and Variables

### Variables

* `$UNAME`: current platform name, in lower case. (In the case of Cygwin, this will always be `cygwin`)

#### Bash Only

* `$COREUTILS`: type of core utility distribution available on the local system. Either `OTHER`, `BSD` or `GNU`.
* `$GCOREUTILS`: when `$COREUTILS` is `BSD`, this may be set to `YES` if there are also GNU core utilities available as, for example, `gls` for GNU `ls`.

### Shortcuts

* `-`: shortcut to `cd -` (change to the previous working directory)
* `..`: go up a directory
* `...`: go up two directories
* `....`: go up three directories
* `cip`: outputs a single IP address for the current system (last line of `ipls` output), usually the one you want - useful for scripts
* `cl`: shortcut to `clear`
* `colourtest`: prints out a table of the main colour codes (borrowed from [iTerm 2](https://code.google.com/p/iterm2/source/browse/trunk/tests/colors.sh))
* `fn`: find files under the current directory by name (uses Spotlight's cache on OS X and `find` on other systems)
* `fl`: shortcut to show the Adobe Flash debug log (OS X Only)
* `gz`: output the current size and gzipped size of a file
* `ipls`: outputs a list of local IP addresses for the current system (works for both Linux and OS X)
* `mkcd`: make a directory and move into it immediately
* `osxdefaults`: (OS X only) configure behaviours for the OS X desktop and applications
* `platformbindir`: outputs the current platform's platform-specific `bin` directory
* `profile`, `p`: utility for updating, editing, installing and loading dotfiles
* `rm!`: shortcut to `rm -rf`
* `shttp`: alias for Python's SimpleHTTPServer - starts an HTTP server for the current working directory
* `title`: set the window title
* `untar`: you can `unzip`, why can't you `untar`?
* `wed`: (Cygwin only) open a file or directory in Sublime Text 2 (if available), otherwise `vim`
* `x`, `:q`: shortcut to `exit`
* `~`: shortcut to change to the home directory

## History

These were originally forked from [seaofclouds](http://github.com/seaofclouds)' [dotfiles repo](https://github.com/seaofclouds/dotfiles), and subsequently heavily modified.  
Lots of inspiration (and some shortcuts and functions) taken from these fine people;
* [Ben Alman](https://github.com/cowboy/dotfiles)
* [Mathias Bynens](http://mths.be/dotfiles)
* [Ryan Tomayko](http://github.com/rtomayko/dotfiles)
* [GitHub does dotfiles](http://dotfiles.github.com/)
