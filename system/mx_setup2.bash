sudo -s <<EOF

function mk_and_push_dir() {
  mkdir -p \$1
  pushd \$1
}

set -x

set -- /Antergos /WD-4TB-1 /Seagate-4TB-1
mkdir \$*
# Fix up /etc/fstab, /etc/lightdm/lightdm.conf, /etc/exports...
mk_and_push_dir /srv/nfs
ln -s \$* .
popd

apt --yes install fonts-hack-ttf fonts-inconsolata fonts-ubuntu-console emacs
apt --yes install tigervnc-common tigervnc-standalone-server
apt --yes purge firefox thunderbird libreoffice-base libreoffice-core

for a in update dist-upgrade autoclean autoremove; do
  apt --yes \$a
done

EOF
