status --is-interactive; or exit

#source (lua ~/.config/z.lua/z.lua --init fish | psub)

set -U _zlua_dir "$XDG_CONFIG_HOME/fisher/github.com/skywind3000/z.lua"


#set _zlua_dir (dirname (status --current-filename))

if test -e $_zlua_dir/z.lua 
	if type -q lua
		lua $_zlua_dir/z.lua --init fish enhanced once echo | source
	else if type -q lua5.3
		lua5.3 $_zlua_dir/z.lua --init fish enhanced once echo | source
	else if type -q lua5.2
		lua5.2 $_zlua_dir/z.lua --init fish enhanced once echo | source
	else if type -q lua5.1
		lua5.1 $_zlua_dir/z.lua --init fish enhanced once echo | source
	else
		echo "init z.lua failed, not find lua in your system"
	end
	alias zc='z -c'      # restrict matches to subdirs of $PWD
	alias zz='z -i'      # cd with interactive selection
	alias zf='z -I'      # use fzf to select in multiple matches
	alias zb='z -b'      # quickly cd to the parent directory
	set -U ZLUA_SCRIPT "$ZLUA_SCRIPT"  2> /dev/null
	set -U ZLUA_LUAEXE "$ZLUA_LUAEXE"  2> /dev/null
end