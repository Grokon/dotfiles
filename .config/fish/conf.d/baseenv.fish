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
#    \V    \\\) ===_____   \\\\\\
#           \V)     \_) \\\\JJ\J\)
#                       /J\JT\JJJJ)
#                       (JJJ| \UUU)
#                        (UU)
# Startup {{{1
# initialized {{{2
set -q fish_initialized; and exit

# locale
if not set -q LANG; or test $LANG = 'C.UTF-8'
  set -x LANG en_US.UTF-8
end

# xdg directories
if not set -q XDG_CONFIG_HOME
  set -x XDG_CONFIG_HOME $HOME/.config
end
if not set -q XDG_DATA_HOME
  set -x XDG_DATA_HOME $HOME/.local/share
end
if not set -q XDG_CACHE_HOME
  set -x XDG_CACHE_HOME $HOME/.cache
end

# wsl
if not set -q WSL; and set -q WSLENV
  set -x WSL (string match -r '^\d.\d.\d-(\d+)-Microsoft$' (uname -r))[2]
  set -x DISPLAY ':0'
  set -x SHELL (command -v fish)
  set -x BROWSER 'powershell.exe Start'
  set -x fish_emoji_width 2
end


# Load custom settings for current OS
# set PLATFORM_SPECIFIC_FILE ~/.config/fish/(uname -s).fish
# if test -f $PLATFORM_SPECIFIC_FILE
#    . $PLATFORM_SPECIFIC_FILE
# else
#    echo Creating platform specific file: $PLATFORM_SPECIFIC_FILE
#    touch $PLATFORM_SPECIFIC_FILE
# end  