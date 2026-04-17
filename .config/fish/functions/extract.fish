function extract --description "Expand or extract bundled & compressed files"
    for file in $argv
        if not test -f "$file"
            echo "'$file' is not a valid file" >&2
            continue
        end

        switch "$file"
            case '*.tar.bz2' '*.tbz2'
                tar xvjf "$file"
            case '*.tar.gz' '*.tgz'
                tar xvzf "$file"
            case '*.tar.xz' '*.txz'
                tar xvJf "$file"
            case '*.tar.zst' '*.tzst'
                tar --use-compress-program=unzstd -xvf "$file"
            case '*.tar.lz4'
                lz4 -d "$file" -c | tar xvf -
            case '*.tar'
                tar xvf "$file"
            case '*.bz2'
                bunzip2 "$file"
            case '*.gz'
                gunzip "$file"
            case '*.xz'
                xz -d "$file"
            case '*.zst'
                unzstd "$file"
            case '*.lz4'
                lz4 -d "$file"
            case '*.zip'
                unzip "$file"
            case '*.rar'
                unrar x "$file"
            case '*.7z'
                7z x "$file"
            case '*.Z'
                uncompress "$file"
            case '*'
                echo "'$file' cannot be extracted via extract()" >&2
        end
    end
end