# Readme ( )



Future request....






# Metadata and File Permissions
A problem with this approach is that your ssh keys need to be secured, but by default Windows files accessed through WSL are readable/writable by everyone and chmod has no affect on Windows files. This can be remedied by re-mounting your Windows partition inside WSL with the metdata option. Edit the /etc/wsl.conf file (create it if it doesn’t exist) and add the following:

```
[automount]
options = "metadata"
```
