#!/usr/bin/bash

# Build up an arch linux system with the default additional packages.

# Install and configure etckeeper to keep track of system changes.
sudo pacman --noconfirm --sync etckeeper
sudo git config --global user.email "acs@alumni.princeton.edu"
sudo git config --global user.name "Vin Shelton"
sudo etckeeper init

# Packages to remove.
remove=(apm
        atp
        electron4
        evolution
        evolution-data-server
        geoip
        gnome-autoar
        gnome-disk-utility
        gnome-icon-theme
        gnome-keyring gnome-screenshot
        gnome-software
        gnome-software-packagekit-plugin
        pragha)

# Packages to add.
install=(borg
         dos2unix
         emacs
         i3-wm
         kitty
         picom
         tigervnc
         tlp
         ttf-cascadia-code
         ttf-hack
         zsh)

# Remove the extraneous packages.
sudo pacman --noconfirm --remove ${remove[*]}

# Install the non-default (essential, in my view) packages.
sudo pacman --noconfirm --sync ${install[*]}

# Update the installed packages.
sudo pacman --noconfirm -Syu

# Initialize the wake on LAN capability.
sudo ethtool -s enp2s0 wol g
#sudo nmcli c modify "Wired connection 1" 802-3-ethernet.wake-on-lan magic

# Local Variables:
# mode: shell-script
# sh-basic-offset: 2
# sh-indentation: 2
# indent-tabs-mode: nil
# End:
