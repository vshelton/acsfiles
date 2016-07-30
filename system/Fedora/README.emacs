
# Set up a Fedora-based system to build emacs

# Clone a git repo
function get_git_repo() {
  # $1 - name of git repo (i.e. emacs)
  # $2 - URL of repo

: ${SCMROOT:=$HOME/scmroot}
  mkdir -p $SCMROOT/gitroot
  cd $SCMROOT/gitroot

  git clone $2
  touch --date=2016-01-01 $1/last_update
  cd ..
  ln -s gitroot/$1
}

project_name=emacs
get_git_repo ${project_name} git://git.savannah.gnu.org/emacs.git

sudo dnf --assumeyes install autoconf automake giflib-devel gnutls-devel libXaw-devel libjpeg-turbo-devel libtiff-devel texinfo

mk-${project_name}

: ${USRLOCAL:=/opt}
cd $USRLOCAL
ln -s ${project_name}-$(today) ${project_name}
cd bin
ln -s ../${project_name}/bin/* .
