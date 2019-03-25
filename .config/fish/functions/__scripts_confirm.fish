# https://github.com/ByScripts/fish-config/blob/master/functions/__byscripts_confirm.fish
#doc
# `__byscripts_confirm $string`: Ask the user to confirm (output: `$string [Yn]`)
#
# Return `0` (Y) or `1` (N) status to use with control structure (`if`, `while`...)
#enddoc

function __scripts_confirm -d "Ask the user a confirmation"
	while true
	    set confirmation (__scripts_ask "$argv [Yn]")
		switch $confirmation
			case '' y Y
				return 0
			case n N
				return 1
		end
	end
end