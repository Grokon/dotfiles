function fish_greeting
  if test -e /var/run/motd.dynamic -a "$SINGLE_COMMAND" != "true"
    set_color 4E9A06
    cat /var/run/motd.dynamic
  end
end
