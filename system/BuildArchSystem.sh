#!/bin/bash

# Build up an arch linux system with the default additional packages.

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
         macchanger
         net-tools
         picom
         tlp
         ttf-cascadia-code
         ttf-hack
         vlc
         yay
         zsh)

# Remove the extraneous packages.
pacman --noconfirm --remove ${remove[*]}

# Install the non-default (essential, in my view) packages.
pacman --noconfirm --sync ${install[*]}
pacman --noconfirm --sync ${borg[*]}
pacman --noconfirm --sync ${vnc[*]}

# Update the installed packages.
pacman --noconfirm -Syu

# Initialize the wake on LAN capability.
#ethtool -s enp2s0 wol g
#nmcli c modify "Wired connection 1" 802-3-ethernet.wake-on-lan magic

# Change TLP to support wake on LAN.
#echo "WOL_DISABLE=N" >> /etc/tlp.conf

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

# Enable system-wide IP address generation.
lfile=/etc/rc.local
echo '#!/bin/bash

sleep 5
macchanger -p wlp2s0
rfkill unblock wifi
dhcpcd wlp2s0' >$lfile
chmod 755 $lfile

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
 WantedBy=multi-user.target" >/etc/systemd/system/rc-local.service
systemctl enable rc-local
systemctl enable sshd

ln -s /usr/share/dhcpcd/hooks/10-wpa_supplicant /usr/lib/dhdpcd/dhcpcd-hooks
echo 'ctrl_interface=/run/wpa_supplicant
ctrl_interface_group=wheel

ap_scan=1

country=US

network={
    ssid="31Cornell"
    psk="Tupac#1Dylan"
}' >/etc/wpa_supplicant.conf

echo "
Copy ssh ID to this system.
Copy kitty configuration here." >&2

# Local Variables:
# mode: shell-script
# sh-basic-offset: 2
# sh-indentation: 2
# indent-tabs-mode: nil
# End:
