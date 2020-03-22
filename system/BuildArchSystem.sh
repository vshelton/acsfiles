#!/usr/bin/bash

# Build up an arch linux system with the default additional packages.

# Install and configure etckeeper to keep track of system changes.
sudo pacman --noconfirm --sync etckeeper
sudo git config --global user.email "acs@alumni.princeton.edu"
sudo git config --global user.name "Vin Shelton"
sudo etckeeper init

# List packages to remove.
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
        pragha
        thunderbird)

# List packages to add.
borg=(borg
      python-llfuse)
i3=(i3status
    i3-wm)
vnc=(lightdm
     lightdm-gtk-greeter
     lightdm-gtk-greeter-settings
     tigervnc)
install=(dos2unix
         emacs
         ethtool
         feh
         kitty
         net-tools
         picom
         tlp
         ttf-cascadia-code
         ttf-hack
         vlc
         yay
         zsh)

# Remove the extraneous packages.
sudo pacman --noconfirm --remove ${remove[*]}

# Install the non-default (essential, in my view) packages.
sudo pacman --noconfirm --sync ${install[*]} ${borg[*]} ${i3[*]} ${vnc[*]}

# Update the installed packages.
sudo pacman --noconfirm -Syu

# Initialize the wake on LAN capability.
#sudo ethtool -s enp2s0 wol g
#sudo nmcli c modify "Wired connection 1" 802-3-ethernet.wake-on-lan magic

# Change TLP to support wake on LAN.
#sudo echo "WOL_DISABLE=N" >> /etc/tlp.conf

# Enable lightdm and tigervnc.
#USER=acs
vncpwfile=/etc/vncpasswd
dmcfg=/etc/lightdm/lightdm.conf

sed -i \
    -e "s/#greeter-session=example-gtk-gnome/greeter-session=lightdm-gtk-greeter/" \
#   -e "s/# autologin-user =.*/autologin-user = ${USER}"/ \
#   -e "s/# autologin-user-timeout =.*/autologin-user-timeout = 0/" \
$dmcfg  
echo "enabled=true
command=Xvnc -rfbauth $vncpwfile -dpi 144
depth=24" | sudo tee -a $dmcfg
echo "Setting up VNC passwd." >&2
sudo vncpasswd $vncpwfile
sudo systemctl enable lightdm.service --force

# Enable system-wide IP address generation.
lfile=/etc/rc.local
echo '#!/bin/bash

sleep 5
rfkill unblock wifi
dhcpcd wlp2s0' | sudo tee -a $lfile
sudo chmod 755 $lfile

echo "[Unit]
 Description=$lfile Compatibility
 ConditionPathExists=$lfile

[Service]
 Type=forking
 ExecStart=$lfile start
 TimeoutSec=0
 StandardOutput=tty
 RemainAfterExit=yes
 SysVStartPriority=99

[Install]
 WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/rc-local.service
sudo systemctl enable rc-local

echo "Copy ssh ID to this system." >&2
echo "Copy kitty configuration here." >&2

# Local Variables:
# mode: shell-script
# sh-basic-offset: 2
# sh-indentation: 2
# indent-tabs-mode: nil
# End:
