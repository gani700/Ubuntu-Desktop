#!/bin/bash


#############################################################################################################################################
# Copyright (C) 

# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by 
# the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

#  You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

#############################################################################################################################################

# CHECKING DISTRIBUTION

DISTCHECK=`cat /etc/issue.net | grep "Ubuntu*"`

if [[ ! "$DISTCHECK" ]]; then 
	echo "These commands are for Ubuntu distros only. Exiting."
	exit 0
fi	

# CHECK FOR GIT

gitInstalled=`which git`

if [ ! "$gitInstalled" ]; then
	sudo apt install git
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

gsettings set org.gnome.desktop.background picture-uri 'file:////$HOME/1920x1200.png'

gsettings set org.gnome.desktop.screensaver picture-uri 'file:////$HOME/1920x1200.png'

gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"

gsettings set org.gnome.desktop.lockdown disable-lock-screen true

# INSTALL G++

checkCompiler=`dpkg --list | grep compiler | grep "g++"`

if [ ! "$checkCompiler" ]; then  
	yes | sudo apt install g++
fi


[ -d $HOME"/.icons" ] || mkdir -p $HOME"/.icons" 

git clone https://github.com/daniruiz/flat-remix 
cp -r flat-remix/Flat-Remix* $HOME"/.icons/" &&
gsettings set org.gnome.desktop.interface icon-theme "Flat-Remix-Dark"


[ -d $HOME"/.themes" ] || mkdir -p $HOME"/.themes"
 
git clone https://github.com/lassekongo83/zuki-themes
mv $HOME"/zuki-themes/*" $HOME"/.themes"


git clone https://github.com/dirruk1/gnome-breeze
mv $HOME"/gnome-breeze/Breeze*" $HOME"/.themes"
mv $HOME"/gnome-breeze/src" $HOME"/.themes"
gsettings set org.gnome.desktop.interface gtk-theme gnome-breeze

#sudo add-apt-repository ppa:webupd8team/gnome3
#sudo apt-get update
#sudo apt-get install gnome-shell-extensions-user-theme

#gnome-shell-extension-tool -e user-theme@gnome-shell-extensions.gcampax.github.com
#gsettings set org.gnome.shell.extensions.user-theme name "Zuki-Shell"

sudo chmod -R 755 /usr/share/themes/Zukitwo
gsettings set org.gnome.shell.extensions.user-theme name "Zukitwo"

cp $HOME"/firefox.svg" $HOME"/.icons/Flat-Remix-Dark/apps/scalable"
rm -rf `find ~/.icons -type f -iname "view-grid-symbolic.svg"`
cp $HOME"view-grid-symbolic.svg" $HOME"/.icons/Flat-Remix-Dark/apps/scalable"

dir=`find /media/ -type d -name "_h*" 2>&1 | grep -v "Permission denied"`

install_vim()
{
	vimIns=$`which vim`
	
	[[ ! "$vimIns" ]] && yes | sudo apt install vim 
	sudo apt install git
	sudo apt install curl
	yes | sudo apt install cmake
	git clone "https://github.com/VundleVim/Vundle.vim.git" 
	mv ~/Vundle.vim ~/.vim/bundle
	mkdir ycm_build && cd ycm_build/
	cd ~/
	mkdir YouCompleteMe/
	git clone "https://github.com/oblitum/YouCompleteMe" 
	mv ~/YouCompleteMe/ ~/.vim/bundle/
	cd
	yes | sudo apt install build-essential cmake
	yes | sudo apt install python-dev python3-dev
	cd ~/.vim/bundle/YouCompleteMe/
	git submodule update --init --recursive
	./install.py --clang-completer
	cd
	
	cmake -G "<generator>" . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/\cpp
	
	#cp $path/0desk_settings/software/.vimrc ~/
	#cp $path/0desk_settings/software/.ycm_extra_conf.py ~/.vim/bundle/YouCompleteMe/third_party/ycmd/examples/
	#git clone https://github.com/Valloric/ycmd/blob/master/\cpp/ycm/.ycm_extra_conf.py 
	#mv ~/.ycm_extra_conf.py ~/.vim/bundle/YouCompleteMe/third_party/ycmd/examples/
	#mv vimrc .vimrc
	cd
}

installClang()
{
	wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
	sudo apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-5.0 main"
	sudo apt update
	sudo apt install -y clang-5.0
}

findOS()
{
	
	dist=`lsb_release -a | grep "Dist*"`
	
	begPath="Distributor ID: "
	
	FLAVOUR=${dist#${begPath}}
	
	distrib=`cat /etc/issue.net`
	wget "http://releases.llvm.org/download.html#5.0.0"
}

installPreBuiltClang()
{
	url="http://releases.llvm.org/5.0.0/clang+llvm-5.0.0-linux-x86_64-ubuntu16.04.tar.xz" 
	echo "export PATH=$dir/home2/clang+llvm-5.0.0-linux-x86_64-ubuntu16.04/bin/:\$PATH" >> ~/.bashrc
}

configureLinks()
{
	cd
	#dir=`find /media/ -type d -name "_h*" 2>&1 | grep -v "Permission denied"`

	#cd $dir/home2/
	#[[ -d "./.vim" ]] && cd ./.vim/ && mv * $dir/ubuntu-gnome/Desktop && cd ..
	ln -s $dir/home2/.vim ~/.vim 
	#cp $dir/ubuntu-gnome/.vim $dir/home2/
	cp $dir/home2/.vimrc ~/
	
	#[[ -d "./.icons" ]] && rm -rf ./.icons && mkdir .icons/ 
	#mv ~/.icons/* $dir/home2/.icons
	ln -s $dir/home2/.icons  ~/.icons
	
	#[[ -d "./.themes" ]] && rm -rf ./.themes && mkdir .themes/ 
	#mv ~/.themes/* $dir/home2/.themes
	ln -s $dir/home2/.themes ~/.themes 
	
	cd
}

installIconsThemes()
{
	#mkdir ~/.icons/
	#git clone https://github.com/daniruiz/flat-remix 

	#cp -r flat-remix/Flat-Remix* ~/.icons/ &&
	gsettings set org.gnome.desktop.interface icon-theme "Flat-Remix-Dark"

	#mkdir ~/.themes
	#git clone https://github.com/lassekongo83/zuki-themes
	#mv ~/zuki-themes/* ~/.themes

	sudo apt install breeze-cursor-theme

	#git clone https://github.com/dirruk1/gnome-breeze
	#mv ~/gnome-breeze/Breeze* ~/.themes
	#mv ~/gnome-breeze/src ~/.themes

	iconToDelete=$(find ~/.icons -type f -iname "view-grid-symbolic.svg" | awk 'NR==2')
	iconsToDelete1=`find /usr/share/icons -type f -iname "view-grid-symbolic.svg"`
	iconsToDelete2=`find ~/.icons -type f -iname "view-grid-symbolic.svg"`
	rm -rf $iconToDelete
	sudo rm -rf $iconToDelete1 
	rm -rf $iconToDelete2
	gsettings set org.gnome.desktop.background picture-uri file:////media/ubuntu-gnome/_home/home2/1920x1200.png

}

prepareDesktop()
{
	sudo apt update
	sudo apt install git
	sudo apt install curl
	sudo apt install gksu
	
	
	yes | sudo apt install cmake
	yes | sudo apt install build-essential cmake
	yes | sudo apt install python-dev python3-dev
	cd
	installPreBuiltClang
	#cd ~/.vim/bundle/YouCompleteMe/
	#git submodule update --init --recursive
	#./install.py --clang-completer
	cd
	
	configureLinks
	installIconsThemes
	source ~/5setup-theme.sh
	#installClang
	
	#install_vim
}

Online=0
for i in $(ls /sys/class/net/ | grep -v lo) 
do
	[[ $(cat /sys/class/net/$i/carrier) = 1 ]] && let OnLine=Online+1
done
[ $OnLine ] &&  echo "Preparing Desktop..." && prepareDesktop  
! [ $Online ] && echo "No Internet Connection!" 



exit 0

