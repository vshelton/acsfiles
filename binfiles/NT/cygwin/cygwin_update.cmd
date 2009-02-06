@echo off

if not exist e:\ goto drive_not_found

zsh -c "echo -n set CYGWIN_SITE=;/c/acs/bin/cygwin_mirrors" > %TEMP%\x.bat

call %TEMP%\x.bat
del /f %TEMP%\x.bat

e:
cd \cygwin\cygwin_repo

rsync -vaz --exclude mail-archives %CYGWIN_SITE% .

rem I tried to use cygwin setup based on desktop shortcut, not default setup in repo,
rem but that caused the rsync window to disappear, so instead, I specify
rem my locally-built latest copy of setup from /usr/local/bin.
rem .\setup --local-install --local-package-dir f:/cygwin/cygwin_repo --no-shortcuts
rem "%HOMEDRIVE%%HOMEPATH%\Desktop\Cygwin Setup.lnk"
e:\cygwin\cygwin_repo\setup-1.7 --local-install --local-package-dir e:/cygwin/cygwin_repo --no-shortcuts
exit

:drive_not_found
echo drive e: not found
pause

