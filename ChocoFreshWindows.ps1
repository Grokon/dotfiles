Set-ExecutionPolicy Unrestricted

## Install Chocolatey
iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex

## Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

## Install Desktop tools
choco install powershell -y
choco install googlechrome -y -y
choco install flashplayerplugin -y
choco install adobereader -y
choco install firefox -y
choco install 7zip -y
choco install skype -y
choco install notepadplusplus.install -y
choco install vlc -y
choco install paint.net -y
choco install chocolateygui -y
choco install itunes -y
choco install whatsapp -y
choco install sublimetext3 -y

## Install Developer Tools
choco install git -y
choco install github -y
choco install sourcetree -y
choco install visualstudiocode -y
choco install microsoft-teams -y
choco install slack -y
choco install visualstudio2017professional -y
choco install resharper -y
choco install clipx -y
choco install terraform -y
choco install azurepowershell -y
choco install azure-cli -y
choco install docker -y
choco install kubernetes-cli -y







# <?xml version="1.0"?>
# <packages>
#     <package id="GoogleChrome" />
#     <package id="Firefox" />
#     <package id="Opera" />
#     <package id="git" />
#     <package id="dropbox" />
#     <package id="nodejs.install" />
#     <package id="ruby" />
#     <package id="winmerge" />
#     <package id="Desktops" />
#     <package id="7zip.install" />
#     <package id="Atom" />
#     <package id="ganttproject" />
#     <package id="Gow" />
#     <package id="putty" />
#     <package id="skitch" />
#     <package id="redis-64" />
#     <package id="redis-desktop-manager" />
#     <package id="vagrant" />
#     <package id="virtualbox" />
#     <package id="mysql.workbench" />
#     <package id="console2" />
#     <package id="TcpView" />
# </packages>

# @powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
# cinst packages.config


# https://github.com/Sharkrit/Windows10init
# https://github.com/W4RH4WK/Debloat-Windows-10
# https://github.com/Disassembler0/Win10-Initial-Setup-Script