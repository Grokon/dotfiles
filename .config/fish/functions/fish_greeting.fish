function fish_greeting
  if test -e /var/run/motd.dynamic -a "$SINGLE_COMMAND" != "true"
    # set_color 4E9A06
    # cat /var/run/motd.dynamic
  else
    
    if test -d /run/WSL
      set -f line1 (uname --kernel-name)" - WSL 2"
    else 
      set -f line1 '(uname --kernel-name)'
    end
    echo "                 ___"
    echo "   ___======____=---=)                  "
    echo " /T            \_--===)                 kernel-name:        " $line1
    echo " [ \ (0)   \~    \_-==)                 nodename:           " (uname --nodename)
    echo "  \      / )J~~    \-=)                 kernel-release:     " (uname --kernel-release)
    echo "   \\___/  )JJ~~~   \)                   kernel-version:     " (uname --kernel-version)
    echo "    \_____/JJJ~~~~    \                 machine:            " (uname --machine)
    echo "    / \  , \J~~~~~     \                processor:          " (uname --processor)
    echo "   (-\)\=|\\\~~~~       L__              hardware-platform:  " (uname --hardware-platform)
    echo "   (\\)  (\\\)_           \==__"
    echo "    \V    \\\) ===_____   \\\\\\"
    echo "           \V)     \_) \\\\JJ\J\)"
    echo "                       /J\JT\JJJJ"
    echo "                       (JJJ| \UUU"
    echo "                        (UU)"
  end
end
