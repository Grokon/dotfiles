function __l_print_help
    printf "Usage: l [DIRECTORY] [OPTIONS]\n\n"
    printf "Description:\n"
    printf "    Print recently modified files from newest to oldest\n\n"
    printf "Examples:\n"
    printf "  l                    # Last few files in current directory\n"
    printf "  l ~/Downloads        # Last few files in another directory\n"
    printf "  l --count 5          # Last 5 files in current directory\n"
    printf "  l ~/Downloads -n 5   # Last 5 files in another directory\n\n"
    printf "Options:\n"
    printf "  -h, --help      Print help and exit\n"
    printf "  -n, --count N   Limit file count (minimum 1)\n"
end

function l --description "Show last n files by newest to oldest"
    argparse h/help n/count= -- $argv
    or return

    if set -q _flag_help
        __l_print_help
        return 0
    end

    set -l count 10
    if set -q _flag_count
        if not string match -qr '^[1-9][0-9]*$' -- $_flag_count
            echo "l: count must be a positive integer" >&2
            return 1
        end
        set count $_flag_count
    end

    switch (count $argv)
        case 0
            command ls -t | head -n $count
        case 1
            if test -d "$argv[1]"
                command ls -t "$argv[1]" | head -n $count
            else
                echo "l: not a directory: $argv[1]" >&2
                return 1
            end
        case '*'
            __l_print_help >&2
            return 1
    end
end