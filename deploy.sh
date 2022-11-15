#!/bin/bash
cd
clear
echo -e "     _        _\n|_| |_ |  |  | |\n| | |_ |_ |_ |_| "



echo
echo "1.xbps 2.apt 3.pacman"
read -p "choose package manager: " opt_pkg_mgr

read -p "install desktop from git (dwm,dmenu,st,slstatus) y/n: " opt_dw
if [ $opt_dw == "y" ]
then 
    read -p "    enable font awesome icons? y/n: " opt_dw_icons
    read -p "    does this device have a battery? y/n:" opt_dw_batt
fi

read -p "install dotfiles? y/n: " opt_dotf

read -p "install packer.nvim? y/n: " opt_pac_nvim

echo esim. neovim neofetch pfetch htop wget curl picon nitrogen
read -p "install additional packages? y/n: " opt_ext_pkg
if [ $opt_ext_pkg == "y" ]
then
    read -p "add optional packages (separated by spaces): " ext_pkg
fi
echo



if [ $opt_pac_nvim == "y" ]
then
    echo installing packer.nvim...
    git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    echo done! installed packer.nvim
fi



echo updating packages...
if [ $opt_pkg_mgr -eq "1" ]
then
    sudo xbps-install -y -Syu
elif [ $opt_pkg_mgr -eq "2" ]
then
    sudo apt update -y
    sudo apt upgrade -y 
elif [ $opt_pkg_mgr -eq "3" ]
then
    sudo pacman -y -Syu
fi
echo done! updating packages



if [ $opt_ext_pkg == "y" ]
then
    echo installing extra packages...
    if [ $opt_pkg_mgr -eq "1" ]
    then
        sudo xbps-install -y $ext_pkg
    elif [ $opt_pkg_mgr -eq "2" ]
    then
        sudo apt install -y $ext_pkg
    elif [ $opt_pkg_mgr -eq "3" ]
    then
        sudo pacman -y -S $ext_pkg
    fi
    echo done! installed extra packages
fi



if [ $opt_dw == "y" ]
then
    echo "installing desktop..."
    echo installing desktop dependencies...
    if [ $opt_pkg_mgr -eq "1" ]
    then
        sudo xbps-install -y  xorg make gcc git libX11-devel libXft-devel libXinerama-devel
    elif [ $opt_pkg_mgr -eq "2" ]
    then
        sudo apt install -y xorg make gcc git libx11-dev libxft-dev libxinerama-dev
    elif [ $opt_pkg_mgr -eq "3" ]
    then
        sudo pacman -y -S xorg make gcc git libx11 libxft libxinerama
    fi
    echo done! installed desktop dependencies
    cd ~
    mkdir .sources
    cd .sources
    mkdir desktop
    cd desktop
    git clone https://github.com/Duom1/dmenu
    git clone https://github.com/Duom1/dwm
    git clone https://github.com/Duom1/st
    git clone https://github.com/Duom1/slstatus
    if [ $opt_dw_icons == "n" ]
    then
        sed -i "/OPT_ICON/d" dwm/config.h
        sed -i "/OPT_ICON/d" slstatus/config.h
    elif [ $opt_dw_icons == "y" ]
    then
        sed -i "/OPT_NO_ICON/d" dwm/config.h
        sed -i "/OPT_NO_ICON/d" slstatus/config.h
    fi
    echo icons part is done
    if [ $opt_dw_batt == "n" ]
    then
        sed -i "/OPT_BATTERY/d" slstatus/config.h
        echo battery part removed
    fi
    cd dmenu
    sudo make clean install
    cd ..
    cd dwm
    sudo make clean install
    cd ..
    cd st
    sudo make clean install
    cd ..
    cd slstatus
    sudo make clean install
    cd ..
    echo done! installing desktop
    cd
fi



if [ $opt_dotf == "y" ]
then
    echo installing dotfiles...
    cd ~/.sources/desktop
    git clone https://github.com/Duom1/dotfiles
    cd dotfiles
    cp .bash_profile ~
    cp .bashrc ~
    cp .inputrc ~
    cp .xinitrc ~
    mkdir ~/.config
    mkdir ~/.config/nvim
    cp init.lua ~/.config/nvim
    echo done! installed dotfiles
fi
