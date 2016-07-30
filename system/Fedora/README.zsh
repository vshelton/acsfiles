
# Set up a Fedora-based system to build zsh

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

project_name=zsh
get_git_repo ${project_name} git://zsh.git.sf.net/gitroot/zsh/zsh

sudo dnf --assumeyes install ftp://fr2.rpmfind.net/linux/opensuse/distribution/13.2/repo/oss/suse/x86_64/yodl-3.03.0-2.1.9.x86_64.rpm
sudo dnf --assumeyes install autoconf pcre-devel texinfo

CFLAGS=-O update-${project_name}

: ${USRLOCAL:=/opt}
cd $USRLOCAL
ln -s ${project_name}-$(today) ${project_name}
cd bin
ln -s ../${project_name}/bin/* .
