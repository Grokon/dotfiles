# https://github.com/ByScripts/fish-config/blob/master/functions/make_completion.fish
function make_completion --argument alias command
	complete -c $alias -xa "(
        set -l cmd (commandline -pc | sed -e 's/^ *\S\+ *//' );
        complete -C\"$command \$cmd\";
    )"
end