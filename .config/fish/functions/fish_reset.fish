function fish_reset --description 'reset local fish configuration'
  # erase all universal variables
  for entry in (set -U)
    set -l variable (string split ' ' $entry)[1]

    if test $variable = 'fish_key_bindings'
      continue
    end

    echo "reset $variable"
    set -eU $variable
  end

  set -l plugins_dir $XDG_CONFIG_HOME/fish/plugins
  if test -d $plugins_dir
    echo "remove $plugins_dir"
    command rm -rf -- $plugins_dir
  end

  # reload configuration
  fish_reload
end