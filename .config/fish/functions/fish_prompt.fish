function fish_prompt
    #export real_status=$status
    #export COLUMNS=$COLUMNS
    # https://github.com/justjanne/powerline-go#fish
    $HOME/bin/powerline-go -shell bare -colorize-hostname -newline -modules nix-shell,venv,user,host,ssh,cwd,dotenv,kube,perms,git,hg,jobs,exit,root,vgo 
    #eval $HOME/bin/powerline-go -error $real_status -shell bare -eval -colorize-hostname -modules-right user
end
