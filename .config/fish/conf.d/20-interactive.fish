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
# Interactive {{{2
if not status --is-interactive
  return
end

# editor aliases
if test "$EDITOR" = nvim
  alias vi="nvim"
  alias vim="nvim"
end

# eza
if type -q eza
  alias ls="eza"
  alias ll="eza -lgh"
  alias la="eza -lagh"
  alias lt="eza -T"
  alias lg="eza -lagh --git"
end

# fd
if type -q fdfind
  alias fd="fdfind"
end

# bat
if type -q batcat
  alias bat="batcat"
  alias cat="bat --color=always"
  set -gx BAT_STYLE "changes,header"
end

# kubectl
if type -q kubectl
  alias k="kubectl"
end

# zoxide
if type -q zoxide
  zoxide init fish | source
end

# just
if type -q just
  alias jserver="just --justfile /etc/justfile"
end

# modern CLI tools
if type -q lazygit
  alias lgit="lazygit"
end
if type -q dust
  alias du="dust -r"
end
if type -q duf
  alias df="duf"
end
if type -q procs
  alias ps="procs"
end

# docker
if type -q docker
  alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
  alias dpsa='docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
end

# nftables
if type -q nft
  alias nftlist='nft list ruleset'
  alias nftfw='nft list table inet firewall'
end

# wsl
if set -q WSLENV
  set -gx SHELL (command -v fish)
  set -g fish_emoji_width 2
  if type -q wslview
    set -gx BROWSER wslview
  else
    set -gx BROWSER 'powershell.exe /c start'
  end
end

# fzf (PatrickF1/fzf.fish)
if type -q fzf
  if type -q fd
    set -g fzf_fd_opts --type f --follow --hidden --exclude .git
  end
  if type -q eza
    set -g fzf_preview_dir_cmd eza --tree --group-directories-first --color=always --icons -L 2
  end
  if type -q bat
    set -g fzf_preview_file_cmd bat --color=always --style=changes,header
  else if type -q batcat
    set -g fzf_preview_file_cmd batcat --color=always --style=changes,header
  end
  set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border --no-bold"
end

# ssh-agent test
if not __ssh_agent_is_started
  __ssh_agent_start
end
