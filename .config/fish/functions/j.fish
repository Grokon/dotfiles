function j --description 'Run local justfile or fall back to /etc/justfile'
    if not type -q just
        echo 'j: just is not installed' >&2
        return 127
    end

    if test -f ./justfile; or test -f ./Justfile
        command just $argv
    else
        command just --justfile /etc/justfile $argv
    end
end