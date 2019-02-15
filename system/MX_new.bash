#!/bin/bash

# Customize an MX linux installation.

# Print the arguments separated by commas and, ultimately, "and".
function print_list() {
  while (( $# > 0 ))
  do
    echo -n "\"$1\""
    shift
    if [[ $# -gt 1 ]]; then
      echo -n ", "
    elif [[ $# -eq 1 ]]; then
      echo -n " and "
    fi
  done
}

# Echo the name of the home directory on the host.
function find_host_home() {
  directory_list=( ${vbox_prefix}${shared_home}/${username}
                   ${vbox_prefix}${shared_home}/${host_user}
                   ${vbox_prefix}${shared_root}/cygwin64/home/${username}
                   ${vbox_prefix}${shared_root}/cygwin64/home/${host_user} )
  for d in ${directory_list[@]}; do
    [[ -d ${d} ]] && echo $d && return 0
  done
  return 1
}

# Echo the name of the zip directory on the host.
function find_host_ziproot {
  directory_list=( ${vbox_prefix}${shared_opt}/zip
                   $(find_host_home)/software/zip )
  [[ -n ${ziproot} ]] &&
    directory_list=( ${ziproot}
                     ${directory_list[@]} )
  for d in ${directory_list[@]}; do
    [[ -d $d ]] && echo $d && break
  done
  if [[ ! -d $d ]]; then
    (
      echo -n "Zip directory not found on host: "
      print_list "${directory_list[@]}"
      echo " were tried.
Set the \"ziproot\" environment variable to a directory on the host. Exiting."
    ) >&2
    exit 1
  fi
 
}

#
# Code starts here.
#

: ${username:=$(whoami)}

# Make sure the directory contining this script is in PATH.
PATH=$(cd $(dirname $0); pwd):$PATH

# Define VirtualBox tag names for shared folders.
vbox_prefix="/media/sf_"
: ${shared_root:=host-root}
: ${shared_home:=host-home}
: ${shared_opt:=host-opt}
: ${host_user:=shelta}

# This build script depends on sudo, so install sudo
# (and reboot to make sure the group permissions get
# propagated) if sudo isn't already installed.
if [[ ! -x /usr/bin/sudo ]]; then
  su -c "apt-get install sudo;
         usermod --append --groups sudo ${username};
         sync;
         reboot" root
fi

# Install mercurial in order to download and execute common scripts.

# Clone my source repo from bitbucket.
cat >.hgrc <<\EOF
# example user config (see "hg help config" for more info)
[ui]
username = Vin Shelton <ethersoft@gmail.com>

[auth]
bb.prefix = https://bitbucket.org
bb.username = acs
bb.password = Ether5802 Bullard

[pager]
ignore = version, help, update, diff

[extensions]
# uncomment these lines to enable some popular extensions
# (see "hg help extensions" for more info)
#
# color =
EOF
chmod 600 .hgrc

sudo apt --yes update
sudo apt --yes install mercurial
export SCMROOT=$HOME/scmroot
t=$SCMROOT/hgroot
mkdir -p $t
(
  cd $t
  hg clone https://acs@bitbucket.org/acs/acs_script acsfiles
)
(
  cd $SCMROOT
  ln -s hgroot/acsfiles
  ln -s hgroot/acsfiles/{binfiles,rcfiles} .
)
export PATH=$SCMROOT/binfiles:$PATH
if ! today >& /dev/null ; then
  echo "$0: 'today' not found in $PATH"
  exit 1
fi

[[ -x /usr/sbin/dmidecode ]] || install-packages dmidecode
host=$(sudo dmidecode -s system-product-name)

# Find the directory containing zip files.
host_home=
ziproot=${ZIPROOT}
if [[ ${host} == "VirtualBox" ]]; then
  ziproot=$(find_host_ziproot)
  host_home=$(find_host_home)
fi

# Install the Z-shell and move aside the customization.
install-packages zsh
if [[ -d /etc/zsh ]]; then
  sudo mv /etc/zsh /etc/ZSH-dist
else
  sudo mkdir /etc/ZSH-dist
  if [[ -d /etc/zypp ]]; then
    sudo mv /etc/zprofile /etc/zsh_completion.d /etc/zshrc /etc/zsh_command_not_found /etc/zshenv /etc/ZSH-dist
  else
    sudo mv /etc/z* /etc/ZSH-dist
  fi
fi

# Create USRLOCAL hierarchy
: ${USRLOCAL:=/opt}
: ${SRCROOT:=$USRLOCAL/src}
sudo chown ${username} ${USRLOCAL}
mkdir ${USRLOCAL}/{bin,build,include,lib,share,src}

# Link startup files.
mv .emacs .emacs-dist >& /dev/null
SCMROOT=${PWD}/${scmbase} ${acs_repo}/binfiles/LinkStartupFiles

# Create a directory for saving shell history and unpack wallpapers.
if [[ -d ${host_home}/.hist ]]; then
  ln -s ${host_home}/.hist
else
  mkdir .hist
fi
tar xf ${ziproot}/wp.tar

# Install Microsoft and Ubuntu fonts.
if suse-pm >/dev/null ; then
  install-packages fetchmsttfonts ubuntu-fonts
  fc-cache -f -v

elif arch-pm >/dev/null ; then
  mkdir -p $SRCROOT/microsoft-fonts
  (
    cd $SRCROOT/microsoft-fonts
    git clone https://aur.archlinux.org/ttf-ms-fonts.git
    (
      cd ./ttf-ms-fonts
      makepkg --syncdeps
      sudo pacman --upgrade --noconfirm ./ttf-ms-fonts-2.0-10-any.pkg.tar.xz
    )
    git clone https://aur.archlinux.org/ttf-tahoma.git
    (
      cd ./ttf-tahoma
      makepkg --syncdeps
      sudo pacman --upgrade --noconfirm ./ttf-tahoma-2.13-2-any.pkg.tar.xz
    )
    # PowerPointViewer.exe has been moved!
    git clone https://aur.archlinux.org/ttf-vista-fonts.git
    (
      cd ./ttf-vista-fonts
      perl -pi.bak -e 's@http://download.microsoft.com/download/E/6/7/E675FFFC-2A6D-4AB0-B3EB-27C9F8C8F696/PowerPointViewer.exe@https://archive.org/download/PowerPointViewer_201801/PowerPointViewer.exe@' PKGBUILD
      makepkg --syncdeps
      sudo pacman --upgrade --noconfirm ./ttf-vista-fonts-1-8-any.pkg.tar.xz
    )
    sudo pacman -Sy ttf-anonymous-pro ttf-dejavu ttf-hack ttf-inconsolata ttf-roboto noto-fonts
  )

elif debian-pm >/dev/null ; then
  # A little too much inside baseball here:
  # knowledge of apt-cache and dpkg.
  # Still, use install-packages for hygiene's sake.
  if [[ -n $(apt-cache search ttf-mscorefonts-installer) ]]; then
    install-packages ttf-mscorefonts-installer
  else
    install-packages cabextract libmspack0
    wget http://ftp.us.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.6_all.deb
    sudo dpkg --install ttf-mscorefonts-installer_3.6_all.deb
  fi

elif fedora-pm >/dev/null ; then
  install-packages cabextract ttmkfdir rpm-build
  rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm

else
  echo "Not a supported OS type." 2>&1
  exit 2
fi

sudo -s <<EOF
set -- /Antergos /WD-4TB-1 /Seagate-4TB-1 /home
mkdir \$*
echo Fix up /etc/fstab, /etc/lightdm/lightdm.conf, /etc/exports...
t=/srv/nfs
mkdir -p \$t
(
  cd \$t
  ln -s \$* .
)

apt --yes purge firefox thunderbird libreoffice-base libreoffice-core
apt --yes install fonts-hack-ttf fonts-inconsolata fonts-ubuntu-console emacs

for t in update dist-upgrade autoclean autoremove; do
  apt --yes \$t
done

t=tigervnc-1.9.0.x86_64.tar.gz
wget --output-document=\$t https://bintray.com/tigervnc/stable/download_file?file_path=\$t
tar xf \$t -C / --strip-components=1
EOF

# Local Variables:
# mode: shell-script
# sh-basic-offset: 2
# sh-indentation: 2
# indent-tabs-mode: nil
# End:
