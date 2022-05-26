# https://github.com/dideler/dotfiles/blob/master/.config/fish/functions/sysinfo.fishhttps://github.com/dideler/dotfiles/blob/master/.config/fish/functions/sysinfo.fish
function sysinfo --description "Gives you a bunch of info about your machine"
  echo kernel-name: (uname --kernel-name)
  echo nodename: (uname --nodename)
  echo kernel-release: (uname --kernel-release)
  echo kernel-version: (uname --kernel-version)
  echo machine: (uname --machine)
  echo processor: (uname --processor)
  echo hardware-platform: (uname --hardware-platform)
  echo operating-system: (uname --operating-system)
end