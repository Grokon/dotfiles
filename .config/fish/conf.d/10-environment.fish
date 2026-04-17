# vim:fdl=1 fdm=marker:
#                 ___
#   ___======____=---=)
# /T            \_--===)
# [ \ (0)   \~    \_-==)
#  \      / )J~~    \-=)
#   \\___/  )JJ~~~   \)
#    \_____/JJJ~~~~    \
#    / \  , \J~~~~~     \
#   (-\)\=|\\\~~~~       L__
#   (\\)  (\\\)_           \==__
#    \V    \\\) ===_____   \\\\\
#           \V)     \_) \\\\JJ\J\)
#                       /J\JT\JJJJ)
#                       (JJJ| \UUU)
#                        (UU)
# Startup {{{1
# Environment {{{2

# locale
if not set -q LANG; or test $LANG = 'C.UTF-8'
  set -gx LANG en_US.UTF-8
end

# xdg directories
if not set -q XDG_CONFIG_HOME
  set -gx XDG_CONFIG_HOME $HOME/.config
end
if not set -q XDG_DATA_HOME
  set -gx XDG_DATA_HOME $HOME/.local/share
end
if not set -q XDG_CACHE_HOME
  set -gx XDG_CACHE_HOME $HOME/.cache
end

# editor
if type -q nvim
  set -gx EDITOR nvim
else
  set -gx EDITOR vim
end

fish_add_path -g $HOME/bin

# ansible
if type -q ansible
  set -gx ANSIBLE_SSH_ARGS "-o ControlMaster=auto -o ControlPersist=60s -o ControlPath=/tmp/ansible-ssh-%h-%p-%r -o ForwardAgent=yes"
end

# homebrew (linux)
if test -x /home/linuxbrew/.linuxbrew/bin/brew
  set -gx HOMEBREW_NO_ANALYTICS 1
  eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)

  if test -d "$HOMEBREW_PREFIX/share/fish/completions"
    contains -- "$HOMEBREW_PREFIX/share/fish/completions" $fish_complete_path; or set -p fish_complete_path "$HOMEBREW_PREFIX/share/fish/completions"
  end
  if test -d "$HOMEBREW_PREFIX/share/fish/vendor_completions.d"
    contains -- "$HOMEBREW_PREFIX/share/fish/vendor_completions.d" $fish_complete_path; or set -p fish_complete_path "$HOMEBREW_PREFIX/share/fish/vendor_completions.d"
  end
end

set -gx CVSEDITOR $EDITOR
set -gx SVN_EDITOR $EDITOR
set -gx GIT_EDITOR $EDITOR

# pager
set -gx PAGER less
set -gx LESS "--RAW-CONTROL-CHARS --LONG-PROMPT --hilite-search --ignore-case --tabs=4 --window=-4"
set -gx LESSHISTFILE /dev/null

# golang
if type -q go
  set -gx GOPATH (go env GOPATH)
  fish_add_path -ga $GOPATH/bin
end

# node.js
set -gx NODENV_ROOT $XDG_DATA_HOME/nodenv
set -gx NPM_CONFIG_CACHE $XDG_CACHE_HOME/npm

# python
set -gx PYENV_ROOT $XDG_DATA_HOME/pyenv
set -gx PIPX_HOME $XDG_DATA_HOME/pipx/venvs
set -gx PIPX_BIN_DIR $XDG_DATA_HOME/pipx/bin
set -gx PIPENV_SHELL_FANCY 1
set -gx PIPENV_VENV_IN_PROJECT 1
set -gx PYLINTHOME $XDG_CACHE_HOME/pylint
fish_add_path -g $HOME/.local/bin

# ruby
set -gx RBENV_ROOT $XDG_DATA_HOME/rbenv
set -gx GEM_SPEC_CACHE $XDG_CACHE_HOME/gem
set -gx GEM_HOME $HOME/gems
fish_add_path -ga $GEM_HOME/bin

# rust
set -gx RUSTUP_HOME $XDG_DATA_HOME/rustup
set -gx CARGO_HOME $XDG_DATA_HOME/cargo

# tools
set -gx GNUPGHOME $HOME/.gnupg
set -gx SSH_AUTH_SOCK $HOME/.ssh/agent.env.sock
set -gx CCACHE_DIR $XDG_CACHE_HOME/ccache
set -gx LIBVIRT_DEFAULT_URI qemu:///system
set -gx HTTPIE_CONFIG_DIR $XDG_CONFIG_HOME/httpie
