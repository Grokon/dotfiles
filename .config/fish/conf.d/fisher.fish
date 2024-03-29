# https://github.com/drrlvn/fish/blob/master/conf.d/fisher.fish
set -g fisher_path $XDG_CONFIG_HOME/fish/plugins

set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..-1]
set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..-1]


for file in $fisher_path/conf.d/*.fish
    builtin source $file 2> /dev/null
end


# if not functions -q fisher
#     echo "Installing fisher for the first time..." >&2
#     #set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
#     curl https://git.io/fisher --create-dirs -sLo $fisher_path/functions/fisher.fish
#     builtin source $fisher_path/functions/fisher.fish 2> /dev/null
#     fish -c fisher
# end

# if not status is-interactive
#     exit 0
# end

if not functions -q fisher
    echo "Installing fisher for the first time..." >&2
    status --is-interactive; 
    and curl -sL git.io/fisher | source; 
    and fisher update
end




