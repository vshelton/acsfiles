
# Save a record of this session
: ${HISTDIR:=$HOME/.hist}
mkdir -p $HISTDIR 2>/dev/null
f=$HISTDIR/$(date '+%Y-%m-%d-%H%M').${HOST%%.*}
mv $acs_session_histfile $f
chmod 400 $f

# Local Variables:
# mode: shell-script
# sh-indentation: 2
# indent-tabs-mode: nil
# End:
