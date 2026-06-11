# Dotfiles

What I do have are a very particular set of dotfiles, dotfiles I have acquired over a very long career. Dotfiles that make unix less of a nightmare for people like me.

## Features

* colourful prompt, directory listing, `man` pages and `git` output
* 2-line prompt with `git` status, clock and command syntax highlighting
* works on macOS, and Linux - and with both GNU and BSD core utilities
* shell history from `↑`/`↓` keys is from the current shell, `^r` is from all (`zsh` only)

## Requirements

* `git` version 1.8 or newer
* **Python 2.6/2.7 and 3.x**
* **Homebrew**  
  _macOS Only - This means you need Xcode installed first_
* `reattach-to-user-namespace`  
  _macOS Only - Allows lots of things to work better inside `tmux`_
* `zsh-syntax-highlighting`
  _Provides syntax highlighting for the `zsh` prompt_
* `ncurses`  
  _If this isn't installed, the `clear` command is missing_
* `Regexp::Common` version `2013031301` or newer  
  _Perl module used for `ipgrep` and `ipls` commands. Older versions do not suport IPv6 and will break._
* **zsh 4.3** or newer  
  _This is not a hard requirement, however, this version is the one supplied with macOS 10.8_

> [!WARNING]
> As of June 2026, Cygwin, `bash`, and `strap` support is no longer actively maintained. I would advise moving to WSL, `zsh`, and manual setup, respectively.

## Setup

Setup involves a few steps specific to macOS, followed by the "all platforms" steps below.

### macOS

* install [Xcode](https://itunes.apple.com/app/xcode/id497799835)
* install [Homebrew](https://github.com/Homebrew/homebrew)
* `brew install reattach-to-user-namespace zsh-syntax-highlighting`

### All Platforms

* install [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
* `cpan Regexp::Common` (frustratingly, will require some basic interaction if you haven't set up CPAN before)
* `git clone https://github.com/ticky/dotfiles.git ~/.dotfiles`
* `~/.dotfiles/install.sh`  
  _**NOTE**: If `install.sh` detects that dependencies are missing, it will notify you and abort._
* Restart your shell

## Updating

`dotfiles update` will fetch the latest changes and install them.

## Platform-specific directories

### Single-Platform

This supports three kinds of platform-specific functionality;

1. Platform-specific `bin` directories
2. Platform-specific `~` includes
3. Platform-specific `zshrc` includes

The install script will manage this automatically. You can find these under `.dotfiles/platforms`.

* Files in `.dotfiles/platforms/{platform}/bin` are automatically available in your `$PATH`.

* Files in `.dotfiles/platforms/{platform}/home` are either symlinked (editing `~/{file}` updates `.dotfiles/platforms/{platform}/file` - platform-specific includes are only possible if the file is executable) or concatenated (appended; this allows platform-specific stuff to be added to files which aren't executed).

* Files in `.dotfiles/platforms/{platform}/zsh` are loaded by `.zshrc` (and thus, only when running `zsh`), in the following order;
    1. `path.zsh` - settings for `$PATH` go here
    2. All files except `path.zsh` and `completion.zsh`, in alphabetical order - general settings and custom categorisation goes here
    3. `completion.zsh` - completion settings go here

This setup includes a helper function for this called `platformbindir`. Running this will;

* create the platform-specific `bin` directory if it doesn't already exist
* output the full location of the platform-specific `bin` directory

So it's easy to add stuff; you can do stuff like ``cd `platformbindir` ``, which navigates straight to the current platform's `bin` directory.

_**NOTE**: Due to the way this works, it's not possible to update a concatenated file in your home directory and commit it immediately. You will need to make the edit twice for those files._

### All-But-Platform

Additionally, there is provision for such directories usable for all but a certain platform. For example, `tmux` works anywhere except on Cygwin, so `tmux.conf.concat` is placed in `.dotfiles/platforms/all-but-cygwin/home`. It then applies on `linux` and `darwin`, but not `cygwin`.

There are no shortcuts for configuring this, however, it relies on the same `$UNAME` variable as the above, so if you had a `linux` directory, the all-but directory is `all-but-linux`.

## History

These were originally forked from [seaofclouds](http://github.com/seaofclouds)' [dotfiles repo](https://github.com/seaofclouds/dotfiles), and subsequently heavily modified.  
Lots of inspiration (and some shortcuts and functions) taken from these fine people;

* [Eevee](https://github.com/eevee/rc)
* [Ben Alman](https://github.com/cowboy/dotfiles)
* [Mathias Bynens](http://mths.be/dotfiles)
* [Ryan Tomayko](http://github.com/rtomayko/dotfiles)
* [GitHub does dotfiles](http://dotfiles.github.com/)
