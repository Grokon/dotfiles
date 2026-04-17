function fish_reload -d 'reload fish configuration'
  # reload all config fragments
  for fragment in $XDG_CONFIG_HOME/fish/conf.d/*.fish
    test -f $fragment -a -r $fragment; and source $fragment
  end
end