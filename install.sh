#!/bin/bash

# Update pkg lists
echo "Updating package lists..."
sudo apt-get update

# zsh install
which zsh > /dev/null 2>&1
if [[ $? -eq 0 ]] ; then
    echo ''
    echo "zsh already installed..."
else
    echo "zsh not found, now installing zsh..."
    echo ''
    sudo apt install zsh -y
fi


# Installing git completion
echo ''
sudo add-apt-repository ppa:neovim-ppa/unstable
echo "Now installing git and bash-completion... ccze - log colarised ... toilet - ascii-gen ..lolcat - color cut"
sudo apt-get install git bash-completion ccze toilet lolcat neovim -y

echo ''
echo "Now configuring git-completion..."
GIT_VERSION=`git --version | awk '{print $3}'`
URL="https://raw.github.com/git/git/v$GIT_VERSION/contrib/completion/git-completion.bash"
echo ''
echo "Downloading git-completion for git version: $GIT_VERSION..."
if ! curl "$URL" --silent --output "$HOME/.git-completion.bash"; then
	echo "ERROR: Couldn't download completion script. Make sure you have a working internet connection." && exit 1
fi

# oh-my-zsh install
if [ -d ~/.oh-my-zsh/ ] ; then
echo ''
echo "oh-my-zsh is already installed..."
read -p "Would you like to update oh-my-zsh now?" -n 1 -r
echo ''
    if [[ $REPLY =~ ^[Yy]$ ]] ; then
    cd ~/.oh-my-zsh && git pull
        if [[ $? -eq 0 ]]
        then
            echo "Update complete..." && cd
        else
            echo "Update not complete..." >&2 cd
        fi
    fi
else
echo "oh-my-zsh not found, now installing oh-my-zsh..."
echo ''
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# oh-my-zsh plugin install
echo ''
echo "Now installing oh-my-zsh plugins..."
echo ''
git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
git clone git://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting


# powerlevel9k install
echo ''
echo "Now installing powerlevel9k..."
echo ''
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

# vimrc vundle install
echo ''
echo "Now installing vundle..."
echo ''
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Pathogen install
echo ''
echo "Now installing Pathogen..."
echo ''
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
	curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# Nerdtree for vim install
echo ''
echo "Now installing Nerdtree for Vim..."
echo ''
git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree

# Vim color scheme install
echo ''
echo "Now installing vim wombat color scheme..."
echo ''
git clone https://github.com/sheerun/vim-wombat-scheme.git ~/.vim/colors/wombat 
mv ~/.vim/colors/wombat/colors/* ~/.vim/colors/

# Vim color scheme install
echo ''
echo "Now installing vim wombat color scheme..."
echo ''
git clone https://github.com/sheerun/vim-wombat-scheme.git ~/.vim/colors/wombat 
mv ~/.vim/colors/wombat/colors/* ~/.vim/colors/

# Speedtest-cli, pip and jq (lightweight and flexible command-line JSON processor) install
echo ''
echo "Now installing Speedtest-cli, pip, tmux and jq..."
echo ''
sudo apt-get install jq tmux -y #python3-pip
#sudo pip install --upgrade pip
#sudo pip install speedtest-cli

# Bash color scheme
echo ''
echo "Now installing solarized dark WSL color scheme..."
echo ''
wget https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.256dark
mv dircolors.256dark .dircolors



# Pull down personal dotfiles
echo ''
read -p "Do you want to use jldeen's dotfiles? y/n" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo ''
	echo "Now pulling down jldeen dotfiles..."
	git clone https://github.com/grokon/dotfiles.git ~/.dotfiles
	echo ''
	cd $HOME/.dotfiles && echo "switched to .dotfiles dir..."
	echo ''
	#echo "Checking out wsl-dev branch..." && git checkout wsl-dev
	#echo ''
	echo "Now configuring symlinks..." && $HOME/.dotfiles/script/bootstrap.sh
    if [[ $? -eq 0 ]]
    then
        echo "Successfully configured your environment with jldeen's dotfiles..."
    else
        echo "jldeen's dotfiles were not applied successfully..." >&2
fi
else 
	echo ''
    echo "You chose not to apply jldeen's dotfiles. You will need to configure your environment manually..."
	echo ''
	echo "Setting defaults for .zshrc and .bashrc..."
	echo ''
	echo "source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc && echo "added zsh-syntax-highlighting to .zshrc..."
	echo ''
	echo "source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc && echo "added zsh-autosuggestions to .zshrc..."
	echo ''
	echo "source $HOME/.git-completion.bash" >> ${ZDOTDIR:-$HOME}/.bashrc && echo "added git-completion to .bashrc..."
	
fi


# Set default shell to zsh
echo ''
read -p "Do you want to change your default shell? y/n" -n 1 -r
echo ''
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo "Now setting default shell..."
    chsh -s $(which zsh)
    if [[ $? -eq 0 ]]
    then
        echo "Successfully set your default shell to zsh..."
    else
        echo "Default shell not set successfully..." >&2
fi
else 
    echo "You chose not to set your default shell to zsh. Exiting now..."
fi

echo ''
echo '	Badass WSL terminal installed! Please reboot your computer for changes to be made.'





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