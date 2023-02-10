set -q fish_initialized; and exit

# fish
set -U fish_greeting

# editor
if type -q nvim
	set -Ux EDITOR nvim
  alias vi="nvim"
  alias vim="nvim"
else
	set -Ux EDITOR vim
end

set -gx PATH $HOME/bin $PATH

# exa
if type -q exa
  alias ls="exa"
  alias l="exa -a"
  alias ll="exa -lgh"
  alias la="exa -lagh"
  alias lt="exa -T"
  alias lg="exa -lagh --git"
  set -U FZF_PREVIEW_DIR_CMD 'exa --tree --group-directories-first -s extension --color always -F -L 2'
end

# fd
if type -q fdfind
  alias fd="fdfind"
end

# bat
if type -q batcat
  alias bat="batcat"
  alias cat="bat --color=always"
  set -U FZF_PREVIEW_FILE_CMD 'bat --color always'
  set -gx BAT_STYLE "changes,header"
end

# ansible
if type -q ansible
  set -Ux ANSIBLE_SSH_ARGS "-o ControlMaster=auto -o ControlPersist=60s -o ControlPath=/tmp/ansible-ssh-%h-%p-%r -o ForwardAgent=yes"
end

# docker
#set -gx DOCKER_HOST tcp://localhost:2375

set -gx CVSEDITOR $EDITOR
set -gx SVN_EDITOR $EDITOR
set -gx GIT_EDITOR $EDITOR

# pager
set -Ux PAGER less
#set -Ux LESS '--RAW-CONTROL-CHARS --tabs=4'
set -Ux LESS "--RAW-CONTROL-CHARS --LONG-PROMPT --hilite-search --ignore-case --tabs=4 --window=-4"
set -Ux LESSHISTFILE /dev/null

#
# toolchains
#

# golang
if type -q go
  set -Ux GOPATH (go env GOPATH)
  set -gx PATH $PATH $GOPATH/bin
end

# node.js
set -Ux NODENV_ROOT $XDG_DATA_HOME/nodenv
set -Ux NPM_CONFIG_CACHE $XDG_CACHE_HOME/npm

# python
set -Ux PYENV_ROOT $XDG_DATA_HOME/pyenv
set -Ux PIPX_HOME $XDG_DATA_HOME/pipx/venvs
set -Ux PIPX_BIN_DIR $XDG_DATA_HOME/pipx/bin
set -Ux PIPENV_SHELL_FANCY 1
set -Ux PIPENV_VENV_IN_PROJECT 1
set -Ux PYLINTHOME $XDG_CACHE_HOME/pylint
set -gx PATH $HOME/.local/bin $PATH

# ruby
set -Ux RBENV_ROOT $XDG_DATA_HOME/rbenv
set -Ux GEM_SPEC_CACHE $XDG_CACHE_HOME/gem
set -Ux GEM_HOME $HOME/gems
set -gx PATH $PATH $GEM_HOME/bin

# rust
set -Ux RUSTUP_HOME $XDG_DATA_HOME/rustup
set -Ux CARGO_HOME $XDG_DATA_HOME/cargo

#
# tools
#

# # (n)vim
# set -Ux VIM_CONFIG_PATH $XDG_CONFIG_HOME/nvim

# gnupg
set -gx GNUPGHOME $HOME/.gnupg

# ccache
set -gx CCACHE_DIR $XDG_CACHE_HOME/ccache

# libvirt
set -gx LIBVIRT_DEFAULT_URI qemu:///system

# httpie
set -gx HTTPIE_CONFIG_DIR $XDG_CONFIG_HOME/httpie

#
# fzf
#

if type -q fd
  set -U FZF_DEFAULT_COMMAND fd --type f --follow --exclude .git
  set -U FZF_FIND_FILE_COMMAND $FZF_DEFAULT_COMMAND
  set -U FZF_CD_COMMAND "fd --type directory --follow"
  set -U FZF_CD_WITH_HIDDEN_COMMAND "fd --type directory --follow --hidden --exclude .git"
  set -U FZF_OPEN_COMMAND $FZF_DEFAULT_COMMAND
end

# plugin (ui)
set -U FZF_LEGACY_KEYBINDINGS 0
set -U FZF_TMUX 1
set -U FZF_TMUX_HEIGHT 25%

# plugin (preview)
set -U FZF_ENABLE_OPEN_PREVIEW 1
set -U FZF_PREVIEW_FILE_COMMAND 'head -n 10'
set -U FZF_PREVIEW_DIR_COMMAND 'ls'

# local
set -U FZF_BASE_OPTS "--height $FZF_TMUX_HEIGHT --no-bold"


# z
set -gx Z_CMD "j"

