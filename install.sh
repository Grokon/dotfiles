#!/bin/bash

# Update pkg lists
echo "Updating package lists..."
sudo apt-get update

# Installing git completion/ jq (lightweight and flexible command-line JSON processor)
echo ''
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-add-repository ppa:fish-shell/release-3
echo "Now installing git and bash-completion... ccze - log colarised ... toilet - ascii-gen ..lolcat - color cut"
sudo apt-get install git bash-completion ccze toilet lolcat neovim fish jq tmux -y

echo ''
echo "Now configuring git-completion..."
GIT_VERSION=`git --version | awk '{print $3}'`
URL="https://raw.githubusercontent.com/git/git/v$GIT_VERSION/contrib/completion/git-completion.bash"
echo ''
echo "Downloading git-completion for git version: $GIT_VERSION..."
if ! curl "$URL" --silent --output "$HOME/.git-completion.bash"; then
	echo "ERROR: Couldn't download completion script. Make sure you have a working internet connection." && exit 1
fi

# Tmux plugin magager install run after symlink
if [ test ! -d "~/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins
fi 



if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end



# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install




ln -s ~/.dotfiles/.config/fish ~/.config/fish

sudo update-alternatives --install /usr/bin/lua lua-interpreter \
/usr/bin/lua5.3 130 --slave /usr/share/man/man1/lua.1.gz \
lua-manual /usr/share/man/man1/lua5.3.1.gz

sudo update-alternatives --install /usr/bin/luac lua-compiler \
/usr/bin/luac5.3 130 --slave /usr/share/man/man1/luac.1.gz \
lua-compiler-manual /usr/share/man/man1/luac5.3.1.gz




~/.tmux/plugins/tpm/scripts/install_plugins.sh




function update-fzf --description "Installs or updates fzf"
  set FZF_VERSION (curl -Ls -o /dev/null -w "%{url_effective}" https://github.com/junegunn/fzf-bin/releases/latest | xargs basename)
  curl -L https://github.com/junegunn/fzf-bin/releases/download/$FZF_VERSION/fzf-$FZF_VERSION-linux_amd64.tgz | tar -xz -C /tmp/
  sudo -p "Root password to install fzf: " mv /tmp/fzf /usr/local/bin/fzf
end



# SpaceVim
curl -sLf https://spacevim.org/install.sh | bash

# ripgrep
$ curl -LO https://github.com/BurntSushi/ripgrep/releases/download/0.10.0/ripgrep_0.10.0_amd64.deb
$ sudo dpkg -i ripgrep_0.10.0_amd64.deb


## Debian
#Для Debian 9.0 запустите от имени root:
echo 'deb http://download.opensuse.org/repositories/shells:/fish/Debian_9.0/ /' > /etc/apt/sources.list.d/shells:fish.list
apt-get update
apt-get install fish
#Вы можете добавить ключ репозитория в apt. Имейте в виду, что владелец ключа может распространять обновления, пакеты и репозитории, которым ваша система будет доверять (подробнее). Для добавления ключа запустите:
wget -nv https://download.opensuse.org/repositories/shells:fish/Debian_9.0/Release.key -O Release.key
apt-key add - < Release.key
apt-get update
#################
echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/2/Debian_9.0/ /' | sudo tee -a /etc/apt/sources.list
wget -q -O - https://download.opensuse.org/repositories/shells:fish:release:2/Debian_9.0/Release.key | sudo apt-key add -
sudo apt update
sudo apt install fish
