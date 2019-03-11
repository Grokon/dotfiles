# A workaround for Fish re-reading config for non-interactive execution:
# https://git.io/yj4KoA
if not status --is-interactive
  exit
end



set -gx PATH /usr/local/bin /usr/sbin $HOME/bin $HOME/go/bin $PATH

# git
set -gx GIT_SSH "$HOME/bin/git-ssh"

## editor
if which vimr > /dev/null
	set -Ux VISUAL 'vimr -s'
else if which gnvim > /dev/null
	set -Ux VISUAL gnvim
else if which mvim > /dev/null
	set -Ux VISUAL mvim
end

if which nvim > /dev/null
	set -Ux EDITOR nvim
else
	set -Ux EDITOR vim
end


# theme defs
set -g theme_display_git_master_branch yes



set -g theme_display_user ssh
set -g theme_display_hostname ssh



set -g theme_display_cmd_duration yes


set -g theme_display_date yes
set -g theme_date_format "+%a %H:%M"





set -g theme_color_scheme zenburn

set -g fish_prompt_pwd_dir_length 0
set -g theme_project_dir_length 1

set -g theme_newline_cursor no