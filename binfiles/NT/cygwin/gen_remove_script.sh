#!/bin/bash
cut -f1 -d' ' < /etc/setup/installed.db | grep -v INSTALLED.DB | xargs --delim='\n' cygcheck -l | xargs --delim='\n' cygpath -w  | sed -e 's/\(.*\)/del "\1"/g' | sort -u > remove-all-cyg-files.bat
