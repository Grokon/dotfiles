# Readme ( )



Future request....




# Z.lua cheat-sheat

```
z foo       # cd to most frecent dir matching foo
z foo bar   # cd to most frecent dir matching foo and bar
z -r foo    # cd to the highest ranked dir matching foo
z -t foo    # cd to most recently accessed dir matching foo
z -l foo    # list matches instead of cd
z -c foo    # restrict matches to subdirs of $PWD
z -e foo    # echo the best match, don't cd
z -i foo    # cd with interactive selection
z -I foo    # cd with interactive selection using fzf
z -b foo    # cd to the parent directory starting with foo
```

# FZF keybinging (`<https://github.com/junegunn/fzf#key-bindings-for-command-line>`)

- `CTRL-T` - Paste the selected files and directories onto the command-line
    - Set `FZF_CTRL_T_COMMAND` to override the default command
    - Set `FZF_CTRL_T_OPTS` to pass additional options
- `CTRL-R` - Paste the selected command from history onto the command-line
    - If you want to see the commands in chronological order, press `CTRL-R`
      again which toggles sorting by relevance
    - Set `FZF_CTRL_R_OPTS` to pass additional options
- `ALT-C` - cd into the selected directory
    - Set `FZF_ALT_C_COMMAND` to override the default command
    - Set `FZF_ALT_C_OPTS` to pass additional options

#### Using the finder

- `CTRL-J` / `CTRL-K` (or `CTRL-N` / `CTRL-P`) to move cursor up and down
- `Enter` key to select the item, `CTRL-C` / `CTRL-G` / `ESC` to exit
- On multi-select mode (`-m`), `TAB` and `Shift-TAB` to mark multiple items
- Emacs style key bindings
- Mouse: scroll, click, double-click; shift-click and shift-scroll on
  multi-select mode

# Metadata and File Permissions
A problem with this approach is that your ssh keys need to be secured, but by default Windows files accessed through WSL are readable/writable by everyone and chmod has no affect on Windows files. This can be remedied by re-mounting your Windows partition inside WSL with the metdata option. Edit the /etc/wsl.conf file (create it if it doesn’t exist) and add the following:

```
[automount]
options = "metadata"
```
