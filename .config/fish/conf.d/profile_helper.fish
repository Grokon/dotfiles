status --is-interactive; or exit

set FISH_THEME base16-tomorrow-night

#set SCRIPT_DIR (realpath (dirname (status -f)))

# load currently active theme...
if test -e $XDG_CONFIG_HOME/fish/themes
  eval sh "$XDG_CONFIG_HOME/fish/themes/$FISH_THEME.sh"
end


# set aliases, like base16_*...
for SCRIPT in $XDG_CONFIG_HOME/fish/themes/*.sh
  set THEME (basename $SCRIPT .sh)
  function $THEME -V SCRIPT -V THEME
    eval sh '"'$SCRIPT'"'
    set -x BASE16_THEME (string split -m 1 '-' $THEME)[2]
    echo -e "if !exists('g:colors_name') || g:colors_name != '$THEME'\n  colorscheme $THEME\nendif" >  ~/.vimrc_background
  end
end
