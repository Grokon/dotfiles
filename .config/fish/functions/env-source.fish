# parse .env file

function env-source
	for line in (/bin/cat $argv | grep -v '^#'| grep -v '^\s*$' )
    set item (string split -m 1 '=' $line)
    set -gx $item[1] $item[2]
    echo "Exported key $item[1]"
	end
end
