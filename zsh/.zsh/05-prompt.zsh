#                 ██      
#                ░██      
#  ██████  ██████░██      
# ░░░░██  ██░░░░ ░██████  
#    ██  ░░█████ ░██░░░██ 
#   ██    ░░░░░██░██  ░██ 
#  ██████ ██████ ░██  ░██ 
# ░░░░░░ ░░░░░░  ░░   ░░  
#
#  ▓▓▓▓▓▓▓▓▓▓
# ░▓ author ▓ xero <x@xero.nu>
# ░▓ code   ▓ http://code.xero.nu/dotfiles
# ░▓ mirror ▓ http://git.io/.files
# ░▓▓▓▓▓▓▓▓▓▓
# ░░░░░░░░░░

#ICO_DIRTY="*"
#ICO_DIRTY="↯ "
ICO_DIRTY="⚡"

#ICO_AHEAD="↑"
ICO_AHEAD=""
#ICO_AHEAD="▲"

#ICO_BEHIND="↓"
ICO_BEHIND=""
#ICO_BEHIND="▼"

#ICO_DIVERGED="↕"
ICO_DIVERGED=""
#ICO_DIVERGED="נּ"


#1d1f21 Background (29,31,33)     234
#282a2e Current Line (40,42,46)   235
#373b41 Selection (55,59,65)      237
#c5c8c6 Foreground (197,200,198)  251
#969896 Comment (150,152,150)     246
#cc6666 Red (204,102,102)         167
#de935f Orange (222,147,95)       173
#f0c674 Yellow (240,198,116)      222
#b5bd68 Green (181,189,104)       143
#8abeb7 Aqua (138,190,183)        109
#81a2be Blue (129,162,190)        109
#b294bb Purple (178,148,187)      139

DEFAULT_BACKGROUND=237

SEPARATOR=" %F{$(( $DEFAULT_BACKGROUND - 3 ))}%f " # ╱ ⎢ 
START_PROMT=" %F{237}"
END_PROMT="%F{237} "
HOST_PROMT=" %F{038} %m"
FOLDER_PROMT="%F{109} %$(( $COLUMNS - 53 ))<...<%~%<<"


COLOR_ROOT="%F{167}"
COLOR_USER="%F{cyan}"
COLOR_NORMAL="%F{159}"


#█▓▒░ allow functions in the prompt
setopt PROMPT_SUBST
autoload -Uz colors && colors

#█▓▒░ colors for permissions
if [[ "$EUID" -ne "0" ]]
then  # if user is not root
	USER_LEVEL="${COLOR_USER}舘"
else # root!
	USER_LEVEL="${COLOR_ROOT}藍"
fi

#█▓▒░ git prompt
GIT_PROMPT() {
  test=$(git rev-parse --is-inside-work-tree 2> /dev/null)
  if [ ! "$test" ]
  then
    echo "${SEPARATOR}"
    return
  fi
  ref=$(git name-rev --name-only HEAD | sed 's!remotes/!!;s!undefined!merging!' 2> /dev/null)
  dirty="" && [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]] && dirty=$ICO_DIRTY
  stat=$(git status | sed -n 2p)
  case "$stat" in
    *ahead*)
      stat=$ICO_AHEAD
    ;;
    *behind*)
      stat=$ICO_BEHIND
    ;;
    *diverged*)
      stat=$ICO_DIVERGED
    ;;
    *)
      stat=""
    ;;
  esac

  #echo "%{$bg[gray]%}%F{cyan} %F{white}${ref}${dirty}${stat} $reset_color%F{gray}▒░"
  #echo "${USER_LEVEL}━[${COLOR_NORMAL}"${ref}${dirty}${stat}"${USER_LEVEL}]"
  echo "${SEPARATOR}%F{107} ${ref}${dirty}${stat}"  
}

#█▓▒░  Prompt ┏ ┗━  ⎡⎣
PROMPT='${START_PROMT}%K{${DEFAULT_BACKGROUND}}${HOST_PROMT}${SEPARATOR}${FOLDER_PROMT}$(GIT_PROMPT)%k${END_PROMT}
  ${USER_LEVEL}%n ━ %f'

#RPROMPT='%F{222}%h' #   %T


#source  ~/.zsh/powerlevel9k/powerlevel9k.zsh-theme

#POWERLEVEL9K_MODE='nerdfont-complete'


    # # Easily switch primary foreground/background colors
    # #DEFAULT_FOREGROUND=038 DEFAULT_BACKGROUND=024 PROMPT_COLOR=038

    # DEFAULT_FOREGROUND=006 DEFAULT_BACKGROUND=235 PROMPT_COLOR=173
    # DEFAULT_FOREGROUND=198 DEFAULT_BACKGROUND=090 PROMPT_COLOR=173
    # DEFAULT_FOREGROUND=235 DEFAULT_BACKGROUND=159 PROMPT_COLOR=173
    # DEFAULT_FOREGROUND=123 DEFAULT_BACKGROUND=059 PROMPT_COLOR=183
    # DEFAULT_FOREGROUND=159 DEFAULT_BACKGROUND=238 PROMPT_COLOR=173
    # DEFAULT_FOREGROUND=159 DEFAULT_BACKGROUND=239 PROMPT_COLOR=172
    # #DEFAULT_COLOR=$DEFAULT_FOREGROUND
    # DEFAULT_COLOR="clear"


##-------------------------PowerLevel9k Set
##-----Prompt Set
## System Status Segments
#background_jobs battery context dir dir_writable disk_usage history host ip vpn_ip public_ip load os_icon ram root_indicator status swap time user vi_mode ssh

## Development Environment Segments
#vcs

## Language Segments
#GO: go_version
#Javascript: node_version nodeenv nvm
#PHP: php_version symfony2tests symfony2_version
#Python: virtualenv anaconda pyenv
#Ruby: chruby rbenv rspec_stats rvm
#Rust: rust_version
#Swift: swift_version

## Cloud Segments
#AWS: aws aws_en_env
#Other: docker_machine kubecontext

## Other Segments
#custom_commmand command_execution_time todo detect_virt newline

# ## Prompt
# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(ssh context root_indicator dir dir_writable vcs)
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs command_execution_time history load)

# ## Double-Lined Prompt
# POWERLEVEL9K_PROMPT_ON_NEWLINE=true
# POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
# #POWERLEVEL9K_RPROMPT_ON_NEWLINE=true

# ##-----Icon Set
# #get_icon_names

# POWERLEVEL9K_ANDROID_ICON=$'\uf17b ' # or '\ue70e' 
# POWERLEVEL9K_APPLE_ICON=$'\uf179 ' #
# POWERLEVEL9K_AWS_EB_ICON=$'\uf270 ' # or 
# POWERLEVEL9K_AWS_ICON=$'\uf1b3 ' # or $'\ue7ad' 
# POWERLEVEL9K_BACKGROUND_JOBS_ICON=$'\uf013 ' #
# POWERLEVEL9K_BATTERY_ICON=$'\uf241 ' # or $'\uf240 ' 
# POWERLEVEL9K_CARRIAGE_RETURN_ICON=$'\u21b5' # ↵
# POWERLEVEL9K_DISK_ICON=$'\uf0a0 ' #
# POWERLEVEL9K_EXECUTION_TIME_ICON="Due" #or $'\uf252 ' 
# POWERLEVEL9K_FAIL_ICON='\u2718' #✘
# POWERLEVEL9K_FOLDER_ICON=$'\uf07b ' #
# POWERLEVEL9K_FREEBSD_ICON="BSD" #or 
# #POWERLEVEL9K_GO_ICON=$'\ue724' # or $'\ue626' 
# POWERLEVEL9K_HOME_ICON=$'\uf015 ' #
# POWERLEVEL9K_HOME_SUB_ICON=$'\uf07c ' #
# #POWERLEVEL9K_LEFT_SEGMENT_END_SEPARATOR=$'\uf105' # or $'\uf12d' 
# POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="%F{$DEFAULT_BACKGROUND}\ue0b0%f" #$'\ue0b0' # 
# POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='%F{$(( $DEFAULT_BACKGROUND - 3 ))}／%f' #$'\ue0b1' #  "%F{000}／%f" # 
# POWERLEVEL9K_LINUX_ICON=$'\uf17c ' #
# POWERLEVEL9K_LOAD_ICON=$'\uf524 ' # or L or $'\uf140 ' 
# POWERLEVEL9K_LOCK_ICON=$'\ue0a2' #
# POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="┏" # ↱
# POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="┗━ ━ " # ↳
# POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX='├─'
# POWERLEVEL9K_NETWORK_ICON=$'\uf012 ' # or $'\uf1fe ' 
# POWERLEVEL9K_NODE_ICON=$'\ue24f' # ⬢
# POWERLEVEL9K_OK_ICON=$'\u2714' #✔ or $'\uf00c ' 
# POWERLEVEL9K_PUBLIC_IP_ICON=$'\uf080 ' # or $'\uf469'  or 
# POWERLEVEL9K_PYTHON_ICON=$'\uf81f' #
# POWERLEVEL9K_RAM_ICON=$'\uf2db ' # or $'\uf0e4 ' 
# POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR='' #$'\ue0b2' #
# POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="" #$'\ue0b3' # "%F{000}／%f" #
# POWERLEVEL9K_ROOT_ICON="\uf0e7 Root" # or \uf292 
# POWERLEVEL9K_RUBY_ICON=$'\ue791' # or $'\ue739' 
# POWERLEVEL9K_RUST_ICON=$'\ue7a8' #
# POWERLEVEL9K_SERVER_ICON=$'\uf233 ' # or $'\uf473' 
# POWERLEVEL9K_SSH_ICON="(ssh)" #$uf120'  or $'\ue795' 
# POWERLEVEL9K_SUNOS_ICON=$'\uf185 ' #
# POWERLEVEL9K_SWAP_ICON=$'\uf0c7 ' # or $'\uf109 ' 
# POWERLEVEL9K_SWIFT_ICON=$'\ue755' #
# POWERLEVEL9K_SYMFONY_ICON=$'\ue757' #
# POWERLEVEL9K_TEST_ICON=$'\ue29a ' #
# POWERLEVEL9K_TODO_ICON=$'\uf046 ' #
# POWERLEVEL9K_VCS_BOOKMARK_ICON=$'\uf02e' # or $'\uf097'  or $'\uf08d'  or $'\uf223'  or ☿
# POWERLEVEL9K_VCS_BRANCH_ICON=$'\uf126 ' # or $'\ue702'  or 
# POWERLEVEL9K_VCS_COMMIT_ICON="-o-" # or $'\ue729' 
# POWERLEVEL9K_VCS_GIT_BITBUCKET_ICON=$'\uf171 ' # or $'\uf172 '  or $'\ue703' 
# POWERLEVEL9K_VCS_GIT_GITHUB_ICON=$'\uf113 ' # or $'\uf09b '  or $'\uf092 ' 
# POWERLEVEL9K_VCS_GIT_GITLAB_ICON=$'\uf296 ' #
# POWERLEVEL9K_VCS_GIT_ICON=$'\uf1d3 ' # or $'\uf1d2' 
# POWERLEVEL9K_VCS_HG_ICON=$'\uf223 ' # or 
# POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON=$'\uf063' # or $'\uf01a'  or $'\uf0ab'  or $'\ud727'  or $'\u2193' ↓
# POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON=$'\uf062' # or $'\uf01b'  or $'\uf0aa'  or $'\ue726'  or $'\u2191' ↑
# POWERLEVEL9K_VCS_REMOTE_BRANCH_ICON=$'\uf061' # or $'\uf18e'  or $'\uf0a9'   or $'\ue725'  or →
# POWERLEVEL9K_VCS_STAGED_ICON=$'\uf067' #✚ or $'\uf055'  or $'\uf0fe' 
# POWERLEVEL9K_VCS_STASH_ICON=$'\uf01c' # or $'\uf192'  or ⍟
# POWERLEVEL9K_VCS_SVN_ICON="SVN" #$'\ue268'  or 
# POWERLEVEL9K_VCS_TAG_ICON=$'\uf02c ' #
# POWERLEVEL9K_VCS_UNSTAGED_ICON=$'\uf111 ' # or $'\uf06a'  or $'\uf12a'  or $'\uf071'  or '\u25CF' ●
# POWERLEVEL9K_VCS_UNTRACKED_ICON=$'\uf128 ' # or $'\uf059'  $'\uf29c'  or $'\u00b1' ?
# POWERLEVEL9K_VPN_ICON="(vpn)"
# POWERLEVEL9K_WINDOWS_ICON=$'\uf17a ' #

# ##-----Color Set
# #for code ({000..255}) print -P -- "$code: %F{$code}This is how your text would look like%f"
# #getColorCode background
# #getColorCode foreground

# POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND='226' #yellow
# POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND='000' #alpha
# POWERLEVEL9K_DIR_DEFAULT_BACKGROUND='039' #blue
# POWERLEVEL9K_DIR_DEFAULT_FOREGROUND='000' #alpha
# POWERLEVEL9K_DIR_HOME_BACKGROUND='039' ##blue
# POWERLEVEL9K_DIR_HOME_FOREGROUND='000' #alpha
# POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='039' #blue
# POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='000' #alpha
# POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND='196' #red
# POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND='226' #yellow
# POWERLEVEL9K_VCS_CLEAN_FOREGROUND='000' #alpha
# POWERLEVEL9K_VCS_CLEAN_BACKGROUND='040' #green or'165' #purple
# POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='000' #alpha
# POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='040' #green
# POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='000' #alpha
# POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='208' #orange
# #POWERLEVEL9K_VI_MODE_INSERT_FOREGROUND='teal'

# POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND='000'  #alpha
# POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND='226' #yellow
# POWERLEVEL9K_STATUS_OK_BACKGROUND='000' #alpha
# POWERLEVEL9K_STATUS_OK_FOREGROUND='040' #green
# POWERLEVEL9K_STATUS_ERROR_BACKGROUND='196' #red
# POWERLEVEL9K_STATUS_ERROR_FOREGROUND='226' #yellow
# POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='196'
# POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='226' #yellow
# POWERLEVEL9K_HISTORY_BACKGROUND='244' #gray
# POWERLEVEL9K_HISTORY_FOREGROUND='000' #alpha
# POWERLEVEL9K_LOAD_CRITICAL_BACKGROUND='196' #red
# POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND='226' #yellow
# POWERLEVEL9K_LOAD_WARNING_BACKGROUND='226' #yellow
# POWERLEVEL9K_LOAD_WARNING_FOREGROUND='000' #alpha
# POWERLEVEL9K_LOAD_NORMAL_BACKGROUND='040' #green
# POWERLEVEL9K_LOAD_NORMAL_FOREGROUND='000' #alpha

# ##-----Others Set
# ## Command-Execution-time set
# POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
# POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=2

# #POWERLEVEL9K_CHANGESET_HASH_LENGTH=6
# #POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"
# POWERLEVEL9K_SHORTEN_DIR_LENGTH=5
# #POWERLEVEL9K_TIME_FORMAT="%D{%H:%M  \uE868  %d.%m.%y}"
