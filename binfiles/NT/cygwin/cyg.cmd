@echo off

rem How to fetch rsync list:
rem wget -O - http://cygwin.com/mirrors.txt | grep rsync | cut -d';' -f1 | sed -e 's;\(rsync://[0-9a-z.-]*\).*;\1;'

rem The current list:
rem rsync://rsync.osuosl.org
rem rsync://sigunix.cwru.edu
rem rsync://mirrors.xmission.com
rem rsync://mirrors.kernel.org
rem rsync://rsync.gtlib.gatech.edu
rem rsync://mirror.etf.bg.ac.yu
rem rsync://ftp.kaist.ac.kr
rem rsync://mirror.averse.net
rem rsync://ftp.esat.net
rem rsync://bo.mirror.garr.it
rem rsync://ftp.gwdg.de
rem rsync://ftp.inf.tu-dresden.de

rem e:
rem cd \cygwin\cygwin-downloads

f:
cd \cygwin-mirror

@echo on

rsync -vaz --exclude mail-archives rsync://mirrors.kernel.org/sourceware/cygwin/ .
rem rsync -vaz --exclude mail-archives rsync://mirrors.xmission.com/cygwin/ .
rem rsync -vaz --exclude mail-archives rsync://rsync.gtlib.gatech.edu/ .

rem .\setup --local-install --local-package-dir e:/cygwin/cygwin-downloads --no-shortcuts
.\setup --local-install --local-package-dir f:/cygwin-mirror --no-shortcuts
