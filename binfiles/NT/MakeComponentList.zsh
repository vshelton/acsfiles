#!/usr/bin/env zsh

# Create a list of XEmacs package components suitable for inclusion
# in the XEmacs.iss file.

emulate -LR zsh
progname=${0:t}

pkg_index=package-index.LATEST.gpg

# Generate a list of all packages
if [[ ! -r $pkg_index ]]; then
  print -u2 $progname: $pkg_index file not found.
  exit 1
fi
all_pkgs=( $(grep '^(' $pkg_index | grep -v '(package-get-update-base-entry' | sed -ne 's/^(//p' | sort ) )

# Set up various categories of packages
mule=( $(grep -i -A 5 'category.*mule' $pkg_index | grep filename | perl -p -e 's/^.*"(.*)-[0-9].[0-9][0-9]-pkg.tar.gz"/\1/') )
fixed=( efs xemacs-base )
minimal=( edit-utils efs texinfo xemacs-base )
recommended=(
  c-support cc-mode debug dired ecb edebug ediff edit-utils efs
  eieio fsf-compat latin-euro-standards latin-unity locale lookup
  mail-lib mule-base net-utils os-utils pc perl-modes prog-modes
  semantic sh-script sounds-wav speedbar texinfo text-modes time
  xemacs-base xemacs-devel
)

# Print out the section header
print '[Components]
Name: "base"; Description: "XEmacs {#XEmacsVersion} executable and essential support files"; Types: complete minimal recommended custom; Flags: fixed'

for p in $all_pkgs; do
  desc=$(grep -A 18 "^(${p}$" $pkg_index | grep description | sed -ne 's/.*"\(.*\)"/\1/p')
  is_mule=0
  foreach pp in $mule; do
    if [[ $pp == $p ]]; then
      is_mule=1
      print "#ifdef MULE"
      break
    fi
  done
  is_fixed=0
  foreach pp in $fixed; do
    if [[ $pp == $p ]]; then
      is_fixed=1
      break
    fi
  done
  is_minimal=0
  foreach pp in $minimal; do
    if [[ $pp == $p ]]; then
      is_minimal=1
      break
    fi
  done
  is_recommended=0
  foreach pp in $recommended; do
    if [[ $pp == $p ]]; then
      is_recommended=1
      break
    fi
  done
  typ="Types: complete custom"
  (( is_minimal )) && typ="$typ minimal"
  (( is_recommended )) && typ="$typ recommended"
  flags=
  (( is_fixed )) && flags="; Flags: fixed"
  print Name: \"${p:gs/-/_/}\"\; Description: \"$p: $desc\"\; $typ$flags
  (( is_mule )) && print "#endif"
done
