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

f:
cd \cygwin\cygwin_repo

if X%CYGWIN_SITE% == X set CYGWIN_SITE="rsync://mirrors.kernel.org/sourceware/cygwin/"

rsync -vaz --exclude mail-archives %CYGWIN_SITE% .

rem I tried to use cygwin setup based on desktop shortcut, not default setup in repo,
rem but that caused the rsync window to disappear, so instead, I specify
rem my locally-built latest copy of setup from /usr/local/bin.
rem .\setup --local-install --local-package-dir f:/cygwin/cygwin_repo --no-shortcuts
rem "%HOMEDRIVE%%HOMEPATH%\Desktop\Cygwin Setup.lnk"
e:\cygwin\usr\local\bin\cygwin-setup --local-install --local-package-dir f:/cygwin/cygwin_repo --no-shortcuts
