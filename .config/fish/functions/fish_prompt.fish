function fish_prompt
    export real_status=$status
    export COLUMNS=$COLUMNS
    # https://github.com/justjanne/powerline-go#fish
    $HOME/bin/powerline-go -shell bare
    #eval $HOME/bin/powerline-go -error $real_status -shell bare -eval -colorize-hostname -modules-right user
end