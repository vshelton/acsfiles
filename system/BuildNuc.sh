#!/bin/bash

# Build up an arch linux server on Nuc with the default additional packages.

if [[ $(id -u) != 0 ]]; then
  echo Must be run as root! >&2
  exit 1
fi

# Install and configure etckeeper to keep track of system changes.
pacman --noconfirm --sync etckeeper
git config --global user.email "acs@alumni.princeton.edu"
git config --global user.name "Vin Shelton"
etckeeper init

# List packages to remove.
remove=(
#   apm
#   atp
#   electron4
#   evolution
#   evolution-data-server
#   geoip
#   gnome-autoar
#   gnome-disk-utility
#   gnome-icon-theme
#   gnome-icon-theme-symbolic
#   gnome-themes-extra
#   gnome-keyring
#   gnome-screenshot
#   gnome-software
#   gnome-software-packagekit-plugin
#   pragha
    thunderbird
)

# List packages to add.
borg=(
      borg
      python-llfuse
)
i3=(
    i3status
    i3-wm
)
vnc=(
     lightdm
     lightdm-gtk-greeter
     lightdm-gtk-greeter-settings
     tigervnc
)
install=(
         dos2unix
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
         zsh
)
kde=(
     xorg
     plasma
     kde-applications
)
yay=(
     binutils
     fakeroot
     gcc
     go
     make
     patch
)

# Remove the extraneous packages.
#pacman --noconfirm --remove ${remove[*]}

# Install the other essential packages.
pacman --noconfirm --sync ${install[*]}
pacman --noconfirm --sync ${borg[*]}
pacman --noconfirm --sync ${vnc[*]}
pacman --noconfirm --sync ${kde[*]}
pacman --noconfirm --sync ${yay[*]}

# Update the installed packages.
pacman --noconfirm -Syu

# Enable lightdm and tigervnc.
#USER=acs
vncpwfile=/etc/vncpasswd
dmcfg=/etc/lightdm/lightdm.conf

#sed -i \
#    -e "s/#greeter-session=example-gtk-gnome/greeter-session=lightdm-gtk-greeter/" \
#   -e "s/# autologin-user =.*/autologin-user = ${USER}"/ \
#   -e "s/# autologin-user-timeout =.*/autologin-user-timeout = 0/" \
#$dmcfg
echo "enabled=true
command=Xvnc -rfbauth $vncpwfile -dpi 144
depth=24" >> $dmcfg

echo "
Setting up VNC passwd." >&2
vncpasswd $vncpwfile
systemctl enable lightdm.service --force

# Clone two gitroot directories.
su - acs <<EOF
mkdir -p ~/scmroot/gitroot
cd  ~/scmroot/gitroot
git clone https://github.com/vshelton/acsfiles
ln -s gitroot/acsfiles acsfiles/binfiles acsfiles/rcfiles ..
git clone https://aur.archlinux.org/yay
cd yay
makepkg -si
EOF

echo "
Copy ssh ID and kitty configuration to this system." >&2

# Local Variables:
# mode: shell-script
# sh-basic-offset: 2
# sh-indentation: 2
# indent-tabs-mode: nil
# End:
