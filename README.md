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


# Metadata and File Permissions
A problem with this approach is that your ssh keys need to be secured, but by default Windows files accessed through WSL are readable/writable by everyone and chmod has no affect on Windows files. This can be remedied by re-mounting your Windows partition inside WSL with the metdata option. Edit the /etc/wsl.conf file (create it if it doesn’t exist) and add the following:

```
[automount]
options = "metadata"
```
