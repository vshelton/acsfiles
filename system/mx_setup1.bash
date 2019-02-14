function mk_and_push_dir() {
  mkdir -p $1
  pushd $1
}

set -x

sudo apt --yes install mercurial
export SCMROOT=$HOME/scmroot
mk_and_push_dir $SCMROOT/hgroot
hg clone https://acs@bitbucket.org/acs/acs_script acsfiles
cp acsfiles/system/build-system ~
popd
chmod 755 build-system
vi build-system
export PATH=$SCMROOT/hgroot/acsfiles/binfiles:$PATH
today
# ./build-system

set +x
