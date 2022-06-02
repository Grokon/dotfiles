# Readme ( )

Future request....

## INSTALL
Via bash:
```
curl -sLf https://raw.githubusercontent.com/Grokon/dotfiles/master/install.sh | bash
```

## [Z.lua cheat-sheat](https://github.com/skywind3000/z.lua)

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

## [FZF keybinging](https://github.com/junegunn/fzf#key-bindings-for-command-line)

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

## Metadata and File Permissions
A problem with this approach is that your ssh keys need to be secured, but by default Windows files accessed through WSL are readable/writable by everyone and chmod has no affect on Windows files. This can be remedied by re-mounting your Windows partition inside WSL with the metdata option. Edit the /etc/wsl.conf file (create it if it doesn’t exist) and add the following:

```
[automount]
options = "metadata,umask=22,fmask=11"
```

# SSHRC

## Usage

sshrc works just like ssh, but it also sources the ~/.sshrc on your local computer after logging in remotely.

    $ echo "echo welcome" >> ~/.sshrc
    $ sshrc me@myserver
    welcome

    $ echo "alias ..='cd ..'" >> ~/.sshrc
    $ sshrc me@myserver
    $ type ..
    .. is aliased to `cd ..'

You can use this to set environment variables, define functions, and run post-login commands. It's that simple, and it won't impact other users on the server - even if they use sshrc too. This makes sshrc very useful if you share a server with multiple users and can't edit the server's ~/.bashrc without affecting them, or if you have several servers that you don't want to configure independently.

## Advanced configuration

Your most import configuration files (e.g. vim, inputrc) may not be bash scripts. Put them in ~/.sshrc.d and sshrc will copy them to a (guaranteed) unique folder in the server's /tmp directory after login. You can find them at `$SSHHOME/.sshrc.d`. You can usually tell programs to load their configuration from the $SSHHOME/.sshrc.d directory by setting the right environment variables. Putting too much data in ~/.sshrc.d will slow down your login times. If the folder contents are > 64kB, the server may block your sshrc attempts.

### Vim

    $ mkdir -p ~/.sshrc.d
    $ echo ':imap <special> jk <Esc>' >> ~/.sshrc.d/.vimrc
    $ cat << 'EOF' >> ~/.sshrc
    export VIMINIT="let \$MYVIMRC='$SSHHOME/.sshrc.d/.vimrc' | source \$MYVIMRC"
    EOF
    $ sshrc me@myserver
    $ vim # jk -> normal mode will work

If you want to load your .vim folder as well, you can 1) put the .vim folder in ~/.sshrc.d, 2) move your .vimrc into the .vim folder, 3) edit the path above to reflect the new .vimrc location, and 4) add the following lines at the top of the moved .vimrc, which will notify vim of the .vim folder location:

    " set default 'runtimepath' (without ~/.vim folders)
    let &runtimepath = printf('%s/vimfiles,%s,%s/vimfiles/after', $VIM, $VIMRUNTIME, $VIM)
    " what is the name of the directory containing this file?
    let s:portable = expand('<sfile>:p:h')
    " add the directory to 'runtimepath'
    let &runtimepath = printf('%s,%s,%s/after', s:portable, &runtimepath, s:portable)

### Tmux

If you use tmux frequently, you can make sshrc work there as well. The following seems complicated, but hopefully it should just work.

    $ cat << 'EOF' >> ~/.sshrc
    alias foo='echo I work with tmux, too'
    
    tmuxrc() {
        local TMUXDIR=/tmp/russelltmuxserver
        if ! [ -d $TMUXDIR ]; then
            rm -rf $TMUXDIR
            mkdir -p $TMUXDIR
        fi
        rm -rf $TMUXDIR/.sshrc.d
        cp -r $SSHHOME/.sshrc $SSHHOME/bashsshrc $SSHHOME/sshrc $SSHHOME/.sshrc.d $TMUXDIR
        SSHHOME=$TMUXDIR SHELL=$TMUXDIR/bashsshrc /usr/bin/tmux -S $TMUXDIR/tmuxserver $@
    }
    export SHELL=`which bash`
    EOF
    $ sshrc me@myserver
    $ tmuxrc
    $ foo
    I work with tmux, too

The -S option will start a separate tmux server. You can still safely access the vanilla tmux server with `tmux`. Tmux servers can persist for longer than your ssh session, so the above `tmuxrc` function copies your configs to the more permenant /tmp/russelltmuxserver, which won't be deleted when you close your ssh session. Starting tmux with the SHELL environment variable set to bashsshrc will take care of loading your configs with each new terminal. Setting SHELL back to /bin/bash when you're done is important to prevent quirks due to tmux sessions having a non-default SHELL variable.

### Specializing .sshrc to individual servers

You may have different configurations for different servers. I recommend the following structure for your ~/.sshrc control flow:

    if [ $(hostname | grep server1 | wc -l) == 1 ]; then
        echo 'server1'
    fi
    if [ $(hostname | grep server2 | wc -l) == 1 ]; then
        echo 'server2'
    fi

### Tips

* I don't recommend trying to throw your entire .vim folder into ~/.sshrc.d. It will more than likely be too big.

* You can avoid duplication of dotfiles using symlinks (e.g. $ cd ~/.sshrc.d && ln -s ../.tmux.conf .tmux.conf/ ).

* For larger configurations, consider copying files to an obscure folder on the server and using ~/.sshrc to automatically source those configurations on login.

* To enable tab completion in zsh, add `compdef sshrc=ssh` to your .zshrc file: