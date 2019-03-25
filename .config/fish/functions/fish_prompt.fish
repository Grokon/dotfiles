function fish_prompt
    export real_status=$status
    export COLUMNS=$COLUMNS
    # https://github.com/justjanne/powerline-go#fish
    $HOME/.dofiles/bin/powerline-go -shell bare
    #eval $HOME/.dofiles/bin/powerline-go -error $real_status -shell bare -eval -colorize-hostname -modules-right user
end