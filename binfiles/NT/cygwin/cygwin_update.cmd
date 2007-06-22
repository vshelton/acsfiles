@echo off

zsh -c "echo -n set CYGWIN_SITE=;/e/acs/bin/cygwin_mirrors" > x.bat

call x.bat
del /f x.bat

f:
cd \cygwin\cygwin_repo

rsync -vaz --exclude mail-archives %CYGWIN_SITE% .

rem I tried to use cygwin setup based on desktop shortcut, not default setup in repo,
rem but that caused the rsync window to disappear, so instead, I specify
rem my locally-built latest copy of setup from /usr/local/bin.
rem .\setup --local-install --local-package-dir f:/cygwin/cygwin_repo --no-shortcuts
rem "%HOMEDRIVE%%HOMEPATH%\Desktop\Cygwin Setup.lnk"
e:\cygwin\usr\local\bin\cygwin-setup --local-install --local-package-dir f:/cygwin/cygwin_repo --no-shortcuts
