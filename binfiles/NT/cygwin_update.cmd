e:
cd \cygwin\cygwin-downloads

rsync -vaz --exclude mail-archives rsync://rsync.osuosl.org/cygwin/ .
rsync -vaz --exclude mail-archives rsync://mirrors.kernel.org/sourceware/cygwin/ .
rem pause

.\setup --local-install --local-package-dir e:/cygwin/cygwin-downloads --no-shortcuts
