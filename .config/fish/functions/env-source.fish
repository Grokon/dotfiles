# parse a .env file

function env-source
    if not set -q argv[1]
        echo "env-source: missing file argument" >&2
        return 1
    end

    if not test -f $argv[1]
        echo "env-source: file not found: $argv[1]" >&2
        return 1
    end

    set -l line_number 0
    while read -l line
        set line_number (math $line_number + 1)
        set -l trimmed (string trim -- $line)

        if test -z "$trimmed"
            continue
        end
        if string match -qr '^#' -- $trimmed
            continue
        end

        set -l normalized (string replace -r '^export\s+' '' -- $trimmed)
        set -l pair (string split -m 1 '=' -- $normalized)
        if test (count $pair) -ne 2
            echo "env-source: skip invalid line $line_number: $trimmed" >&2
            continue
        end

        set -l key (string trim -- $pair[1])
        set -l raw_value $pair[2]

        if not string match -qr '^[A-Za-z_][A-Za-z0-9_]*$' -- $key
            echo "env-source: skip invalid variable name on line $line_number: $key" >&2
            continue
        end

        set -l value
        set -l stripped (string trim -- $raw_value)
        if string match -qr '^".*"\s*$' -- $stripped
            set value (string replace -r '^"(.*)"\s*$' '$1' -- $stripped)
            set value (string replace -a '\\n' '\n' -- $value)
            set value (string replace -a '\\r' '\r' -- $value)
            set value (string replace -a '\\t' '\t' -- $value)
            set value (string replace -a '\\"' '"' -- $value)
            set value (string replace -a '\\\\' '\\' -- $value)
        else if test (string sub -s 1 -l 1 -- $stripped) = "'"; and test (string sub -s -1 -l 1 -- $stripped) = "'"
            set value (string sub -s 2 -l (math (string length -- $stripped) - 2) -- $stripped)
        else
            set value (string replace -r '\s+#.*$' '' -- $raw_value)
            set value (string trim -- $value)
        end

        set -gx $key $value
        echo "Exported $key"
    end < $argv[1]
end
