#  ██                        ██
# ░██                       ░██
# ░██       ██████    ██████░██      ██████  █████ 
# ░██████  ░░░░░░██  ██░░░░ ░██████ ░░██░░█ ██░░░██
# ░██░░░██  ███████ ░░█████ ░██░░░██ ░██ ░ ░██  ░░ 
# ░██  ░██ ██░░░░██  ░░░░░██░██  ░██ ░██   ░██   ██
# ░██████ ░░████████ ██████ ░██  ░██░███   ░░█████ 
# ░░░░░░   ░░░░░░░░ ░░░░░░  ░░   ░░ ░░░     ░░░░░  
#
#  ▓▓▓▓▓▓▓▓▓▓
# ░▓ author ▓ grokon
# ░▓ code   ▓ https://git.io/JJGii
# ░▓ File:  ▓ bashrc
# ░▓▓▓▓▓▓▓▓▓▓
# ░░░░░░░░░░
#
# =============================================================== #

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

#-------------------------------------------------------------
# Source global definitions (if any)
#-------------------------------------------------------------

# Initialize Homebrew environment
if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Set main editor
if command -v nvim >/dev/null 2>&1; then
    export EDITOR="nvim"
    alias vi="nvim"
    alias vim="nvim"
else
    [ -z "$EDITOR" ] && export EDITOR="vim"
    alias vi="vim"
fi
[ -z "$VISUAL" ] && export VISUAL="$EDITOR"

#-------------------------------------------------------------
# Some settings
#-------------------------------------------------------------

#set -o nounset     # These two options are useful for debugging.
#set -o xtrace
#alias debug="set -o nounset; set -o xtrace"

ulimit -S -c 0      # Don't want coredumps.
set -o notify

# Enable options:
shopt -s cdable_vars
shopt -s checkwinsize   # Update window size after every command
shopt -s no_empty_cmd_completion
shopt -s cmdhist        # Save multi-line commands as one command
shopt -s histappend histreedit histverify
shopt -s extglob        # Necessary for programmable completion.

shopt -s globstar 2>/dev/null  # Turn on recursive globbing (enables ** to recurse all directories)

# Disable options:
shopt -u mailwarn
unset MAILCHECK        # Don't want my shell to warn me of incoming mail.

## Better Directory Navigation ##

# Prepend cd to directory names automatically
shopt -s autocd 2>/dev/null
# Correct spelling errors during tab-completion
shopt -s dirspell 2>/dev/null
# Correct spelling errors in arguments supplied to cd
shopt -s cdspell 2>/dev/null

#-------------------------------------------------------------
# History settings
#-------------------------------------------------------------

export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'

# Huge history. Doesn't appear to slow things down, so why not?
HISTSIZE=500000
HISTFILESIZE=100000
HISTIGNORE="&:[ ]*:bg:fg:ll:h:history:clear:exit" # Don't record some commands
# Use standard ISO 8601 timestamp
HISTTIMEFORMAT="[%F %T] "
HISTCONTROL="ignoreboth:erasedups"  # Avoid duplicate entries

# Write each command to the history file immediately
case ";${PROMPT_COMMAND:-};" in
    *";history -a;"*) ;;
    *) PROMPT_COMMAND="history -a${PROMPT_COMMAND:+;$PROMPT_COMMAND}" ;;
esac

#-------------------------------------------------------------
# Greeting, motd, etc.
#-------------------------------------------------------------

# Color definitions (taken from Color Bash Prompt HowTo).
# Some colors might look different of some terminals.
# For example, I see 'Bold Red' as 'orange' on my screen,
# hence the 'Green' 'BRed' 'Red' sequence I often use in my prompt.

# Color Prefix
case ${TERM} in
  xterm-*)
        CPR="\e"
        ;;
    *)
        CPR="\x1b"               
        ;;
esac

# Normal colors
Black=$CPR'[0;30m'        # Black
Red=$CPR'[0;31m'          # Red
Green=$CPR'[0;32m'        # Green
Yellow=$CPR'[0;33m'       # Yellow
Blue=$CPR'[0;34m'         # Blue
Purple=$CPR'[0;35m'       # Purple
Cyan=$CPR'[0;36m'         # Cyan
White=$CPR'[0;37m'        # White

# Bold colors
BBlack=$CPR'[1;30m'       # Black
BRed=$CPR'[1;31m'         # Red
BGreen=$CPR'[1;32m'       # Green
BYellow=$CPR'[1;33m'      # Yellow
BBlue=$CPR'[1;34m'        # Blue
BPurple=$CPR'[1;35m'      # Purple
BCyan=$CPR'[1;36m'        # Cyan
BWhite=$CPR'[1;37m'       # White

# Background colors
On_Black=$CPR'[40m'       # Black
On_Red=$CPR'[41m'         # Red
On_Green=$CPR'[42m'       # Green
On_Yellow=$CPR'[43m'      # Yellow
On_Blue=$CPR'[44m'        # Blue
On_Purple=$CPR'[45m'      # Purple
On_Cyan=$CPR'[46m'        # Cyan
On_White=$CPR'[47m'       # White

NC=$CPR'[m'               # Color Reset

ALERT=${BWhite}${On_Red} # Bold White on red background

printf "%b\n" "${BCyan}This is BASH ${BRed}${BASH_VERSION%.*}${BCyan} - DISPLAY on ${BRed}$DISPLAY${NC}"
date
if command -v fortune >/dev/null 2>&1; then
    fortune -s     # Makes our day a bit more fun.... :-)
fi

# function _exit()              # Function to run upon exit of shell.
# {
#     echo -e "${BRed}Hasta la vista, baby${NC}"
# }
# trap _exit EXIT

#-------------------------------------------------------------
# Shell Prompt - for many examples, see:
#       http://www.debian-administration.org/articles/205
#       http://www.askapache.com/linux/bash-power-prompt.html
#       http://tldp.org/HOWTO/Bash-Prompt-HOWTO
#       https://github.com/nojhan/liquidprompt
#-------------------------------------------------------------
# Current Format: [TIME USER@HOST PWD] >
# TIME:
#    Green     == machine load is low
#    Orange    == machine load is medium
#    Red       == machine load is high
#    ALERT     == machine load is very high
# USER:
#    Cyan      == normal user
#    Orange    == SU to user
#    Red       == root
# HOST:
#    Cyan      == local session
#    Green     == secured remote connection (via ssh)
#    Red       == unsecured remote connection
# PWD:
#    Green     == more than 10% free disk space
#    Orange    == less than 10% free disk space
#    ALERT     == less than 5% free disk space
#    Red       == current user does not have write privileges
#    Cyan      == current filesystem is size zero (like /proc)
# >:
#    White     == no background or suspended jobs in this shell
#    Cyan      == at least one background job in this shell
#    Orange    == at least one suspended job in this shell
#
#    Command is added to the history file each time you hit enter,
#    so it's available to all shells (using 'history -a').

# Test connection type:
if [ -n "${SSH_CONNECTION}" ]; then
    CNX=${Green}        # Connected on remote machine, via ssh (good).
elif [[ "${DISPLAY%%:0*}" != "" ]]; then
    CNX=${ALERT}        # Connected on remote machine, not via ssh (bad).
else
    CNX=${BCyan}        # Connected on local machine.
fi

# Test user type:
if [[ ${USER} == "root" ]]; then
    SU=${Red}           # User is root.
elif [[ ${USER} != $(logname 2>/dev/null) ]]; then
    SU=${BRed}          # User is not login user.
else
    SU=${BCyan}         # User is normal (well ... most of us are).
fi

# Get cpu count
NCPU=$(nproc 2>/dev/null || grep -c '^[Pp]rocessor' /proc/cpuinfo)

SLOAD=$(( 100*${NCPU} ))        # Small load
MLOAD=$(( 200*${NCPU} ))        # Medium load
XLOAD=$(( 400*${NCPU} ))        # Xlarge load

# get current load
load() {
    local load
    read load _ < /proc/loadavg
    echo "$load" | tr -d '.'
}

# Returns a color indicating system load.
load_color() {
    local sysload
    sysload=$(load)

    if [ "$sysload" -gt "$XLOAD" ]; then
        echo -en ${ALERT}
    elif [ "$sysload" -gt "$MLOAD" ]; then
        echo -en ${Red}
    elif [ "$sysload" -gt "$SLOAD" ]; then
        echo -en ${BRed}
    else
        echo -en ${Green}
    fi
}

# Returns a color according to free disk space in $PWD.
disk_color() {
    if [ ! -w "${PWD}" ] ; then
        echo -en ${Red}
        # No 'write' privilege in the current directory.
    elif [ -s "${PWD}" ] ; then
        local used
        used=$(command df -P "$PWD" |
               awk 'END {print $5} {sub(/%/,"")}')
        if [ "$used" -gt 95 ]; then
            echo -en ${ALERT}           # Disk almost full (>95%).
        elif [ "$used" -gt 90 ]; then
            echo -en ${BRed}            # Free disk space almost gone.
        else
            echo -en ${Green}           # Free disk space is ok.
        fi
    else
        echo -en ${Cyan}
        # Current directory is size '0' (like /proc, /sys etc).
    fi
}

# Returns a color according to running/suspended jobs.
job_color() {
    local suspended_jobs running_jobs

    suspended_jobs=$(jobs -s | wc -l)
    running_jobs=$(jobs -r | wc -l)

    if [ "$suspended_jobs" -gt 0 ]; then
        echo -en ${BRed}
    elif [ "$running_jobs" -gt 0 ] ; then
        echo -en ${BCyan}
    fi
}
# Now we construct the prompt.
case ${TERM} in
  *term | xterm-* | rxvt | linux)
        # Time of day (with load info):
        PS1="\[\$(load_color)\][\A\[${NC}\] "
        # User@Host (with connection type info):
        PS1=${PS1}"\[${SU}\]\u\[${NC}\]@\[${CNX}\]\h\[${NC}\] "
        # PWD (with 'disk space' info):
        PS1=${PS1}"\[\$(disk_color)\]\W]\[${NC}\] "
        # Prompt (with 'job' info):
        PS1=${PS1}"\[\$(job_color)\]>\[${NC}\] "
        # Set title of current xterm:
        PS1=${PS1}"\[\e]0;[\u@\h] \w\a\]"
        ;;
    *)
        PS1="(\A \u@\h \W) > " # --> PS1="(\A \u@\h \w) > "
                               # --> Shows full pathname of current dir.
        ;;
esac
#-------------------------------------------------------------
# Tailoring 'less'
#-------------------------------------------------------------

command -v lesspipe >/dev/null 2>&1 && eval "$(SHELL=/bin/sh lesspipe)"
export PAGER=less
export LESS='-R -i -M -S'

# LESS man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\x1b[01;31m'
export LESS_TERMCAP_md=$'\x1b[01;31m'
export LESS_TERMCAP_me=$'\x1b[0m'
export LESS_TERMCAP_se=$'\x1b[0m'
export LESS_TERMCAP_so=$'\x1b[01;44;33m'
export LESS_TERMCAP_ue=$'\x1b[0m'
export LESS_TERMCAP_us=$'\x1b[01;32m'

#============================================================
#
#  ALIASES AND FUNCTIONS
#
#  Arguably, some functions defined here are quite big.
#  If you want to make this file smaller, these functions can
#+ be converted into scripts and removed from here.
#
#============================================================

#-------------------
# Personal Aliases
#-------------------

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
# -> Prevents accidentally clobbering files.
alias mkdir='mkdir -p'

alias h='history'
alias ..='cd ..'

# Pretty-print PATH variables:
alias path='printf "%b\n" "${PATH//:/\\n}"'
alias libpath='printf "%b\n" "${LD_LIBRARY_PATH//:/\\n}"'

alias du='du -h'     # Makes a more readable output.
alias df='df -kTh'

#-------------------------------------------------------------
# The 'ls' family
#-------------------------------------------------------------

if command -v dircolors >/dev/null 2>&1; then
    if [ -r ~/.dircolors ]; then
        eval "$(dircolors -b ~/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -ltr'         #  Sort by date, most recent last.

# eza (modern ls)
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --color=auto --group-directories-first'
    alias ll='eza -l --color=auto --group-directories-first'
    alias la='eza -la --color=auto --group-directories-first'
    alias lt='eza --tree --color=auto'
fi

# bat (modern cat)
if command -v bat >/dev/null 2>&1; then
    alias cat='bat --style=auto'
fi

# zoxide (smart cd)
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash)"
fi

#-------------------------------------------------------------
# Utility functions
#-------------------------------------------------------------

# Find files by name (case-insensitive)
ff() { find . -type f -iname "*${1:-}*" -ls; }

# Find files by name and run a command on them (default: file)
fe() { find . -type f -iname "*${1:-}*" -exec ${2:-file} {} \; ; }

# Find a string in files with highlighting
fstr() {
    OPTIND=1
    local mycase=""
    local usage="fstr: find string in files.
Usage: fstr [-i] \"pattern\" [\"filename pattern\"]"
    while getopts :i opt; do
        case "$opt" in
            i) mycase="-i" ;;
            *) echo "$usage"; return 1 ;;
        esac
    done
    shift $((OPTIND - 1))
    if [ "$#" -lt 1 ]; then
        echo "$usage"
        return 1
    fi
    find . -type f -name "${2:-*}" -print0 \
      | xargs -0 grep -E --color=always -sn "${mycase}" -- "$1" 2>/dev/null | less -R
}

# Swap two files
swap() {
    local TMPFILE=tmp.$$
    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e "$1" ] && echo "swap: $1 does not exist" && return 1
    [ ! -e "$2" ] && echo "swap: $2 does not exist" && return 1
    mv "$1" "$TMPFILE"
    mv "$2" "$1"
    mv "$TMPFILE" "$2"
}

# Extract archives of various formats
extract() {
    if [ ! -f "$1" ]; then
        echo "'$1' is not a valid file"
        return 1
    fi
    case "$1" in
        *.tar.bz2)   tar xvjf "$1"      ;;
        *.tar.gz)    tar xvzf "$1"      ;;
        *.tbz2)      tar xvjf "$1"      ;;
        *.tgz)       tar xvzf "$1"      ;;
        *.tar)       tar xvf "$1"       ;;
        *.bz2)       bunzip2 "$1"       ;;
        *.gz)        gunzip "$1"        ;;
        *.zip)       unzip "$1"         ;;
        *.rar)       unrar x "$1"       ;;
        *.Z)         uncompress "$1"    ;;
        *.7z)        7z x "$1"          ;;
        *.tar.xz)    tar xvf "$1"       ;;
        *.txz)       tar xvf "$1"       ;;
        *.xz)        xz -d "$1"         ;;
        *.tar.zst)   tar --use-compress-program=unzstd -xvf "$1" ;;
        *.tzst)      tar --use-compress-program=unzstd -xvf "$1" ;;
        *.zst)       unzstd "$1"        ;;
        *.tar.lz4)   lz4 -d "$1" -c | tar xvf - ;;
        *.lz4)       lz4 -d "$1"        ;;
        *)           echo "'$1' cannot be extracted via extract()" ; return 1 ;;
    esac
}

# Create a tar.gz archive from a directory
maketar() { tar cvzf "${1%%/}.tar.gz" "${1%%/}/"; }

# Create a zip archive from a file or directory
makezip() { zip -r "${1%%/}.zip" "$1"; }

# Normalize file and directory permissions
sanitize() { chmod -R u=rwX,g=rX,o= "$@"; }

# Repeat a command N times
repeat() {
    local i max
    max="$1"; shift
    for ((i=1; i <= max; i++)); do
        eval "$@"
    done
}

#-------------------------------------------------------------
# SSH agent:
#-------------------------------------------------------------
# Note: ~/.ssh/environment should not be used, as it
#       already has a different purpose in SSH.
export SSH_ENV="$HOME/.ssh/agent.env"

# Note: Don't bother checking SSH_AGENT_PID. It's not used
#       by SSH itself, and it might even be incorrect
#       (for example, when using agent-forwarding over SSH).

agent_is_running() {
    [ -n "$SSH_AUTH_SOCK" ] || return 1

    # ssh-add returns:
    #   0 = agent running, has keys
    #   1 = agent running, no keys
    #   2 = agent not running
    ssh-add -l >/dev/null 2>&1; [ $? -le 1 ]
}

if ! agent_is_running && [ -f "$SSH_ENV" ]; then
    . "$SSH_ENV" >/dev/null 2>&1
fi

if ! agent_is_running; then
    ssh-agent -s >"$SSH_ENV"
    chmod 600 "$SSH_ENV"
    . "$SSH_ENV" >/dev/null 2>&1
fi

# if your keys are not stored in ~/.ssh/id_rsa or ~/.ssh/id_dsa, you'll need
# to paste the proper path after ssh-add
# if ! ssh-add -l >/dev/null 2>&1; then
#     ssh-add
# fi

# unset SSH_ENV

#-------------------------------------------------------------
# FZF
#-------------------------------------------------------------

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#-------------------------------------------------------------
# Just / server helpers
#-------------------------------------------------------------

if command -v just >/dev/null 2>&1; then
    # Default global justfile
    JUST_GLOBAL_FILE=/etc/justfile

    # just completion
    if just --completions bash >/dev/null 2>&1; then
        source <(just --completions bash 2>/dev/null)
    fi

    # Wrapper function:
    # - if the current directory has justfile/Justfile -> use regular just
    # - otherwise -> use the global justfile
    j() {
        if [ -f ./justfile ] || [ -f ./Justfile ]; then
            command just "$@"
        else
            command just --justfile "$JUST_GLOBAL_FILE" "$@"
        fi
    }

    # Explicit call to the global justfile
    alias jserver="just --justfile /etc/justfile"

    # Bind just completion to the wrapper and alias.
    if declare -F _clap_complete_just >/dev/null 2>&1; then
        complete -o default -F _clap_complete_just j
        complete -o default -F _clap_complete_just jserver
    fi
fi

#-------------------------------------------------------------
# Docker helpers
#-------------------------------------------------------------

if command -v docker >/dev/null 2>&1; then
    alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
    alias dpsa='docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'

    # dlogs <container> [lines]
    dlogs() {
        local container="$1"
        local lines="${2:-200}"
        if [ -z "$container" ]; then
            echo "Usage: dlogs <container> [lines]" >&2
            return 1
        fi
        docker logs -f --tail="$lines" "$container"
    }
fi

#-------------------------------------------------------------
# nftables shortcuts
#-------------------------------------------------------------

if command -v nft >/dev/null 2>&1; then
    alias nftlist='nft list ruleset'
    alias nftfw='nft list table inet firewall'
fi

#-------------------------------------------------------------
# User aliases/extensions (~/.bash_aliases)
#-------------------------------------------------------------

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

#-------------------------------------------------------------
# Bash completion
#-------------------------------------------------------------

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

if [ -f ~/.git-completion.bash ]; then
    source ~/.git-completion.bash
    PS1=${PS1}'$(__git_ps1 " (\[\033[35m\]%s\[\033[0m\])") \$ '
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    GIT_PS1_SHOWUNTRACKEDFILES=1
    GIT_PS1_SHOWUPSTREAM="auto"
fi

# Local Variables:
# mode:shell-script
# sh-shell:bash
# End: