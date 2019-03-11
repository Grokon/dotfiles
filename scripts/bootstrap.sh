#!/usr/bin/env bash
#
# bootstrap installs things.

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)

set -e

echo ''

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

setup_gitconfig () {
  if ! [ -f git/gitconfig.local.symlink ]
  then
    info 'setup gitconfig'

    git_credential='cache'
    if [ "$(uname -s)" == "Linux" ]
    then
      git_credential='credential.helper'
    fi

    user ' - What is your github author name?'
    read -e git_authorname
    user ' - What is your github author email?'
    read -e git_authoremail

    sed -e "s/AUTHORNAME/$git_authorname/g" -e "s/AUTHOREMAIL/$git_authoremail/g" -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" git/gitconfig.local.symlink.example > git/gitconfig.local.symlink

    success 'gitconfig'
  fi
}


link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}

install_dotfiles () {
  info 'installing dotfiles'

  local overwrite_all=false backup_all=false skip_all=false

  for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
  do
    dst="$HOME/.$(basename "${src%.*}")"
    link_file "$src" "$dst"
  done
}

setup_gitconfig
install_dotfiles

# If we're on a Mac, let's install and setup homebrew.
if [ "$(uname -s)" == "Darwin" ]
then
  info "installing dependencies"
  if source bin/dot | while read -r data; do info "$data"; done
  then
    success "dependencies installed"
  else
    fail "error installing dependencies"
  fi
fi
## JD edit

#backup old bin, if exists
if [ -e $HOME/bin ]
then
    echo ''
    echo "current $HOME/bin folder found!!! Creating backup..."
    sudo mv $HOME/bin bin_old
else
    echo ''
    echo "No current $HOME/bin folder found. Proceeding to link bin folder for tumx scripts..."
fi

# symlink .dotfiles bin to ~
ln -s $HOME/.dotfiles/bin $HOME/bin

# # symlink .dotfiles tmux to ~ & plugin mgr install
ln -s $HOME/.dotfiles/tmux $HOME/.tmux
# Tmux Plugin Manager
echo ''
echo "Now installing tmux plugin manager..."
echo ''
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


# install Source Code Pro nerd font on Linux systems (not wsl) and configure terminal
# https://github.com/yktoo/yktools/blob/master/gnome-terminal-profile
if [ ! -e /mnt/c/Users ]
then
  sudo cp $HOME/.dotfiles/Source\ Code\ Pro\ Nerd\ Font\ Complete\ Mono.ttf /usr/local/share/fonts
  sudo chown root /usr/local/share/fonts/Source\ Code\ Pro\ Nerd\ Font\ Complete\ Mono.ttf
  sudo fc-cache -fv
  $HOME/.dotfiles/terminal/gnome-terminal-profile import $HOME/.dotfiles/terminal/terminal.gnome && echo "terminal profile loaded successfully!"
  # symlink VSCode User Settings
  if [ -e $HOME/.config/Code/User ]
  then
    ln -s $HOME/.dotfiles/code/settings.json $HOME/.config/Code/User/settings.json && echo "VS Code settings.json applied successfully!"
  else
    echo "No installation of VS Code found. Will not attempt to symlink VS Code settings.json."
  fi
fi

echo ''
echo '  All installed!'