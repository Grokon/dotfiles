# https://github.com/edouard-lopez/tmux-tomorrow/blob/master/tomorrow-night.tmux
# Color key:
#   #1d1f21 Background
#   #282a2e Current Line
#   #373b41 Selection
#   #c5c8c6 Foreground
#   #969896 Comment
#   #cc6666 Red
#   #de935f Orange
#   #f0c674 Yellow
#   #b5bd68 Green
#   #8abeb7 Aqua
#   #81a2be Blue
#   #b294bb Purple


## set status bar
set -g status-bg default
setw -g window-status-current-bg "#282a2e"
setw -g window-status-current-fg "#81a2be"

## highlight active window
setw -g window-style 'bg=#282a2e'
setw -g window-active-style 'bg=#1d1f21'
setw -g pane-active-border-style ''

## highlight activity in status bar
setw -g window-status-activity-fg "#8abeb7"
setw -g window-status-activity-bg "#1d1f21"

## pane border and colors
set -g pane-active-border-bg default
set -g pane-active-border-fg "#373b41"
set -g pane-border-bg default
set -g pane-border-fg "#373b41"

set -g clock-mode-colour "#81a2be"
set -g clock-mode-style 24

set -g message-bg "#8abeb7"
set -g message-fg "#000000"

set -g message-command-bg "#8abeb7"
set -g message-command-fg "#000000"

# message bar or "prompt"
set -g message-bg "#2d2d2d"
set -g message-fg "#cc99cc"

set -g mode-bg "#1d1f21"
set -g mode-fg "#de935f"

# right side of status bar holds "[host name] (date time)"
set -g status-right-length 100
set -g status-right-fg black
set -g status-right-attr bold
set -g status-right '#[fg=#f99157,bg=#2d2d2d] %H:%M |#[fg=#6699cc] %y.%m.%d '

# make background window look like white tab
set-window-option -g window-status-bg default
set-window-option -g window-status-fg white
set-window-option -g window-status-attr none
set-window-option -g window-status-format '#[fg=#6699cc,bg=colour235] #I #[fg=#999999,bg=#2d2d2d] #W #[default]'

# make foreground window look like bold yellow foreground tab
set-window-option -g window-status-current-attr none
set-window-option -g window-status-current-format '#[fg=#f99157,bg=#2d2d2d] #I #[fg=#cccccc,bg=#393939] #W #[default]'

# active terminal yellow border, non-active white
set -g pane-border-bg default
set -g pane-border-fg "#999999"
set -g pane-active-border-fg "#f99157"