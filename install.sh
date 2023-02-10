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
USER=$(whoami)
[[ -z $XDG_CONFIG_HOME ]] && XDG_CONFIG_HOME=$HOME/.config
mkdir -p "$XDG_CONFIG_HOME"

# Installing git completion/ jq (lightweight and flexible command-line JSON processor)
echo ''
# latest neovim version
if ! [ -x "$(command -v nvim)" ]; then
  echo 'Installing neovim'
  sudo add-apt-repository -y ppa:neovim-ppa/unstable
  sudo apt-get install -y neovim
fi
# latest fish version 
if ! [ -x "$(command -v fish)" ]; then
  echo 'Installing fish'
  sudo apt-add-repository -y ppa:fish-shell/release-3
  sudo apt-get install -y fish
fi
# latest git version
if ! [ -x "$(command -v git)" ]; then
  echo 'Installing git'
  sudo add-apt-repository -y ppa:git-core/ppa
  sudo apt-get install -y git
fi
# Update pkg lists
echo "Updating package..."
sudo apt-get update && sudo apt-get upgrade -y
# Install packages
echo "Now installing git and bash-completion... ccze - log colarised ... toilet - ascii-gen ..lolcat - color cut"
sudo apt-get install bash-completion ccze toilet lolcat zsh jq tmux fd-find exa bat ripgrep fzf make -y

# install docker
if type -f docker >/dev/null; then
    echo "docker is already installed"
else
    echo "Installing docker..."
    sudo mkdir -m 0755 -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
  	"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  	$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker $USER
fi

# install bash-completion
echo ''
echo "Now configuring git-completion..."
GIT_VERSION=$(git --version | awk '{print $3}')
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

# isntall .dotfiles
echo ''
if [ ! -d "$DOTPATH" ]; then
  echo "Cloning .dotfiles..."
  git clone https://github.com/Grokon/dotfiles.git "$DOTPATH"
else
  echo "Updating .dotfiles..."
  cd "$DOTPATH" && git pull && cd ~
fi


# Create symlinks
echo ''
echo "Now create symlinks..."


:ask() {
    echo -n ":: Press y to $1: "
    read result </dev/tty
    if [[ "$result" != "y" ]]; then
        return 1
    fi
}


cd $DOTPATH
for file in .??*; do
  [[ "$file" == ".git" ]] && continue
  [[ "$file" == ".DS_Store" ]] && continue
  if [[ "$file" == ".bin" ]]; then
    mkdir -p $HOME/bin
    find "$DOTPATH/.bin/" -type f -perm 0755 -exec ln -fvns {} $HOME/bin/ \;
    continue
  fi
  if [[ "$file" == ".config" ]]; then
    find "$DOTPATH/.config" -maxdepth 1 -mindepth 1 -exec ln -fvns {} "$XDG_CONFIG_HOME/" \;
    continue
  fi
  if [[ "$file" == ".gnupg" ]]; then
    if [[ -L  $HOME/"$file" ]]; then
      ls -lah  $HOME/"$file"
      if ! :ask "remove  $HOME/$file"; then
        echo "skipping"
        continue
      fi
      rm -rf $HOME/"$file"
    fi
    mkdir -p "$HOME/.gnupg"
    chmod 700 "$HOME/.gnupg"
    find "$DOTPATH/.gnupg" -maxdepth 1 -mindepth 1 -exec ln -fvns {} "$HOME/.gnupg" \;
    continue
  fi
  if [[ ! -L  $HOME/"$file" ]]; then
    if [[ -f $HOME/"$file" ]]; then
      ls -lah  $HOME/"$file"
      if ! :ask "remove  $HOME/$file"; then
          echo "skipping"
          continue
      fi
      rm -rf  $HOME/"$file"
    fi
    ln -fvns "$DOTPATH/$file" "$HOME/$file"
  fi
done
cd $HOME




# Tmux plugin magager install run after symlink
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm 
    $HOME/.tmux/plugins/tpm/bin/install_plugins
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
sudo chsh -s /usr/bin/fish


# # LunarVim
# if [ ! -d "$HOME/.config/nvim" ]; then
#     mkdir -p "$HOME/.config/nvim"
# fi
# bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) --no-install-dependencies


# SpaceShip - https://spacevim.org/quick-start-guide/
#curl -sLf https://spacevim.org/install.sh | bash


# check WSL
if [ -f /proc/version ]; then
    if grep -qi microsoft /proc/version; then
        echo "WSL detected - add WSL parameters"
        {\
        echo '[automount]'; \
        echo 'options = "metadata,umask=22,fmask=11"'; \
        echo ''; \
        echo '# Set a command to run when a new WSL instance launches.'; \
        echo '[boot]'; \
        echo 'command = service docker start'; \
        }| sudo tee /etc/wsl.conf

    fi
fi 


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
