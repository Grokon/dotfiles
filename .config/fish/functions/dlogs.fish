function dlogs --description 'Follow docker logs for a container' --argument-names container lines
    if not type -q docker
        echo 'dlogs: docker is not installed' >&2
        return 127
    end

    if test -z "$container"
        echo 'Usage: dlogs <container> [lines]' >&2
        return 1
    end

    if test -z "$lines"
        set lines 200
    end

    docker logs -f --tail="$lines" "$container"
end