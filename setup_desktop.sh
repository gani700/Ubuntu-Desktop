#!/bin/bash


##########################################################################################################
# Copyright (C) gani700 https://github.com/gani700/

# This program is free software: you can redistribute it and/or modify it under the terms of the GNU 
# General Public License as published by the Free Software Foundation, either version 3 of the License, 
# or (at your option) any later version.

# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without 
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General 
# Public License for more details.

#  You should have received a copy of the GNU General Public License along with this program. If not, 
# see http://www.gnu.org/licenses/.

###########################################################################################################

# CHECKING DISTRIBUTION

DISTCHECK=`cat /etc/issue.net | grep "Ubuntu*"`

if [ "$EUID" -ne 0 ]; then
	 echo "Please run as root"
	 exit 0
fi

if [ ! "$DISTCHECK" ]; then 
	echo "These commands are for Ubuntu distros only. Exiting."
	exit 0
fi	

# CHECK FOR GIT

gitInstalled=`which git`

if [ ! "$gitInstalled" ]; then
	yes | sudo apt install git
fi 

# TILIX INSTALLATION

sudo add-apt-repository ppa:webupd8team/terminix

sudo apt update 

sudo apt install tilix

sudo apt install chrome-gnome-shell

# POWERLINE INSTALLATION

sudo apt install python-pip

pip install --user git+git://github.com/Lokaltog/powerline

wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf\ 
https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf

[ -d $HOME"/.fonts/" ] || mkdir -p $HOME"/.fonts/" 
mv PowerlineSymbols.otf $HOME"/.fonts/"

fc-cache -vf $HOME"/.fonts/"

mkdir -p ~/.config/fontconfig/conf.d/ && mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

firstRow="if [ -f ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh ]; then"
secondRow="\    source ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh"
thirdRow="fi"

sed -i -e "\$a$firstRow" -e "\$a$secondRow" -e "\$a$thirdRow"  $HOME"/.bashrc"

# THEME SETTINGS

sudo apt install breeze-cursor-theme

gsettings set org.gnome.desktop.background picture-uri 'file:////$HOME/Ubuntu-Desktop/1920x1200.png'

gsettings set org.gnome.desktop.screensaver picture-uri 'file:////$HOME/Ubuntu-Desktop/1920x1200.png'

gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"

gsettings set org.gnome.desktop.lockdown disable-lock-screen true

# INSTALL G++

checkCompiler=`dpkg --list | grep compiler | grep "g++"`

if [ ! "$checkCompiler" ]; then  
	yes | sudo apt install g++
fi

# INSTALL ICON THEME

[ -d $HOME"/.icons" ] || mkdir -p $HOME"/.icons" 

git clone https://github.com/daniruiz/flat-remix 
cp -r $HOME"/flat-remix/Flat-Remix*" $HOME"/.icons/" &&
gsettings set org.gnome.desktop.interface icon-theme "Flat-Remix-Dark"

# INSTALL GTK+ THEME & SHELL THEME

[ -d $HOME"/.themes" ] || mkdir -p $HOME"/.themes"
 
git clone https://github.com/lassekongo83/zuki-themes
mv $HOME"/zuki-themes/Zuki-shell" $HOME"/.themes"

git clone https://github.com/dirruk1/gnome-breeze
mv $HOME"/gnome-breeze/Breeze*" $HOME"/.themes"
mv $HOME"/gnome-breeze/src" $HOME"/.themes"
gsettings set org.gnome.desktop.interface gtk-theme "Breeze-gtk"

sudo chmod -R 755 ~/.themes/Zuki-shell
gsettings set org.gnome.shell.extensions.user-theme name "Zuki-shell"

# MODIFY "START ICON"

cp $HOME"/Ubuntu-Desktop/firefox.svg" $HOME"/.icons/Flat-Remix-Dark/apps/scalable"
rm -rf `find ~/.icons -type f -iname "view-grid-symbolic.svg"`
cp $HOME"view-grid-symbolic.svg" $HOME"/.icons/Flat-Remix-Dark/apps/scalable"

[ -d $HOME"/.local/share/gnome-shell/extensions" ] || mkdir -p $HOME"/.local/share/gnome-shell/extensions"

# INSTALL GNOME SHELL EXTENSIONS

git clone https://github.com/nls1729/acme-code
cp -R $HOME"/acme-code" $HOME"/.local/share/gnome-shell/extensions"

git clone https://github.com/home-sweet-gnome/dash-to-panel
cp -R $HOME"/dash-to-panel" $HOME"/.local/share/gnome-shell/extensions"

gnome-shell --replace

exit 0
