#! /bin/bash
# source -  https://raw.githubusercontent.com/blackb1rd/Script-Pentool/master/update.sh
# Directory hierarchy
# /pentest┬>exploits──┬>exploitdb
#         │           ├>set
#         │           └>msf
#         ├>database───>sqlmap
#         ├>tutorial───>pwnwiki
#         └>web───────┬>nikto
#                     └>w3af


gitpull () {
    cd "$1" && git pull -v
}

github () {
    txtbld=$(tput bold)
    echo "${txtbld}$(tput setaf 1)[-] Updating $3, please wait...$(tput sgr0)"
    if [ ! -d "$2" ]; then
        git clone "git://github.com/$1" "$2"
    else
        gitpull "$2"
    fi
    wait
    echo "${txtbld}$(tput setaf 4)[>] $3 updated successfully!$(tput sgr0)"
}

if [ ! -d "/pentest" ]; then
	mkdir "/pentest"
fi
if [ ! -d "/pentest/exploits" ]; then
	mkdir "/pentest/exploits"
fi
if [ ! -d "/pentest/database" ]; then
	mkdir "/pentest/database"
fi
if [ ! -d "/pentest/tutorial" ]; then
	mkdir "/pentest/tutorial"
fi
if [ ! -d "/pentest/web" ]; then
	mkdir "/pentest/web"
fi

github offensive-security/exploit-database /pentest/exploits/exploitdb Exploitdb
github trustedsec/social-engineer-toolkit /pentest/exploits/set SET
github rapid7/metasploit-framework /pentest/exploits/msf MSF
github sqlmapproject/sqlmap /pentest/database/sqlmap SQLMap
github pwnwiki/pwnwiki.github.io /pentest/tutorial/pwnwiki PwnWiki
github sullo/nikto /pentest/web/nikto Nikto
github andresriancho/w3af /pentest/web/w3af w3af
