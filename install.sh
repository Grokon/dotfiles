#!/usr/bin/env bash
#  ██
# 
# ░██   ░██     ██
# ░██   ░████   ██
# ░██   ░██ ░██ ██
# ░██   ░██  ░████
# ░██   ░██   ░███ 
# ░░░   ░░░    ░░░ stall
#
#  ▓▓▓▓▓▓▓▓▓▓
# ░▓ author ▓ grokon
# ░▓ code   ▓ https://git.io/JJGii
# ░▓ File:  ▓ install.sh
# ░▓▓▓▓▓▓▓▓▓▓
# ░░░░░░░░░░
#
# =============================================================== #

set -eo pipefail
DOTPATH="$HOME/.dotfiles"
[[ -z $XDG_CONFIG_HOME ]] && XDG_CONFIG_HOME=$HOME/.config

# Installing git completion/ jq (lightweight and flexible command-line JSON processor)
echo ''
# latest neovim version
sudo add-apt-repository ppa:neovim-ppa/stable
# latest fish version 
sudo apt-add-repository ppa:fish-shell/release-3
# latest git version
sudo add-apt-repository ppa:git-core/ppa
# Update pkg lists
echo "Updating package lists..."
sudo apt-get update
# Install packages
echo "Now installing git and bash-completion... ccze - log colarised ... toilet - ascii-gen ..lolcat - color cut"
sudo apt-get install git bash-completion ccze toilet lolcat neovim fish zsh jq tmux fd-find exa bat ripgrep fzf -y

echo ''
echo "Now configuring git-completion..."
GIT_VERSION=`git --version | awk '{print $3}'`
URL="https://raw.githubusercontent.com/git/git/v$GIT_VERSION/contrib/completion/git-completion.bash"
echo ''
echo "Downloading git-completion for git version: $GIT_VERSION..."
if ! curl "$URL" --silent --output "$HOME/.git-completion.bash"; then
	echo "ERROR: Couldn't download completion script. Make sure you have a working internet connection." && exit 1
fi


# # install fzf
# echo ''
# echo "Install fzf..."
# git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
# ~/.fzf/install


# Create symlinks
echo ''
echo "Now create symlinks..."


:ask() {
    echo -n ":: Press y to $1:"
    read result </dev/tty
    if [[ "$result" != "y" ]]; then
        return 1
    fi
}


for file in .??*; do
  [[ "$file" == ".git" ]] && continue
  [[ "$file" == ".gitignore" ]] && continue
  [[ "$file" == ".DS_Store" ]] && continue
  [[ "$file" == ".travis.yml" ]] && continue
  if [[ "$file" == ".config" ]]; then
    mkdir -p "$XDG_CONFIG_HOME"
    find "$DOTPATH/.config" -maxdepth 1 -mindepth 1 -exec ln -fvns {} "$XDG_CONFIG_HOME/" \;
  fi
  if [[ ! -L  $HOME/"$file" ]]; then
      ls -lah  $HOME/"$file"
      if ! :ask "remove  $HOME/$file"; then
          echo "skipping"
          continue
      fi
      rm -rf  $HOME/"$file"

      dir=$(dirname  $HOME/"$file")
      if [[ ! -d "$dir" ]]; then
          mkdir -p "$dir"
      fi

      ln -fvns "$DOTPATH/$file" "$HOME/$file"
  fi
done

# bin
mkdir -p ~/bin
find "$DOTPATH/bin/" -type f -perm 0755 -exec ln -fvns {} $HOME/bin/ \;



# Tmux plugin magager install run after symlink
if [ ! -d "~/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm 
    ~/.tmux/plugins/tpm/bin/install_plugins
fi 

#######################################################


# sudo update-alternatives --install /usr/bin/lua lua-interpreter \
# /usr/bin/lua5.3 130 --slave /usr/share/man/man1/lua.1.gz \
# lua-manual /usr/share/man/man1/lua5.3.1.gz

# sudo update-alternatives --install /usr/bin/luac lua-compiler \
# /usr/bin/luac5.3 130 --slave /usr/share/man/man1/luac.1.gz \
# lua-compiler-manual /usr/share/man/man1/luac5.3.1.gz


# function update-fzf --description "Installs or updates fzf"
#   set FZF_VERSION (curl -Ls -o /dev/null -w "%{url_effective}" https://github.com/junegunn/fzf-bin/releases/latest | xargs basename)
#   curl -L https://github.com/junegunn/fzf-bin/releases/download/$FZF_VERSION/fzf-$FZF_VERSION-linux_amd64.tgz | tar -xz -C /tmp/
#   sudo -p "Root password to install fzf: " mv /tmp/fzf /usr/local/bin/fzf
# end

# change def shell to fish
chsh -s /usr/bin/fish


# LunarVim
bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)




# ## Debian
# #Для Debian 9.0 запустите от имени root:
# echo 'deb http://download.opensuse.org/repositories/shells:/fish/Debian_9.0/ /' > /etc/apt/sources.list.d/shells:fish.list
# apt-get update
# apt-get install fish
# #Вы можете добавить ключ репозитория в apt. Имейте в виду, что владелец ключа может распространять обновления, пакеты и репозитории, которым ваша система будет доверять (подробнее). Для добавления ключа запустите:
# wget -nv https://download.opensuse.org/repositories/shells:fish/Debian_9.0/Release.key -O Release.key
# apt-key add - < Release.key
# apt-get update
# #################
# echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/2/Debian_9.0/ /' | sudo tee -a /etc/apt/sources.list
# wget -q -O - https://download.opensuse.org/repositories/shells:fish:release:2/Debian_9.0/Release.key | sudo apt-key add -
# sudo apt update
# sudo apt install fish




# #install GO / check version https://golang.org/dl/
# curl https://dl.google.com/go/go1.12.7.linux-amd64.tar.gz | sudo tar xzf - -C /usr/local



# https://starship.rs/install.sh - auto install starship - TODO analyze 
