function goenv -d 'go environment manager'
  set command $argv[1]
  set -e argv[1]

  switch $command
  case rehash shell
    . (goenv "sh-$command" $argv|psub)
    #command goenv sh-$command $argv | source
  case '*'
    command goenv $command $argv
  end
end