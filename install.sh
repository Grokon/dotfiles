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
URL="https://raw.github.com/git/git/v$GIT_VERSION/contrib/completion/git-completion.bash"
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



ln -s ~/.dofiles/.config/fish ~/.config/fish

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


