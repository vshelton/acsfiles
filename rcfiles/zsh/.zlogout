
# Save a record of this session
if [[ -e $acs_session_histfile ]]; then
  exec 2>/dev/null
  chmod 400 $acs_session_histfile
  : ${HISTDIR:=$HOME/.hist}
  mkdir -p $HISTDIR
  cd $HISTDIR
  mv $acs_session_histfile $(date '+%Y-%m-%d-%H%M').${HOST%%.*}
fi

# Local Variables:
# mode: shell-script
# sh-indentation: 2
# indent-tabs-mode: nil
# End:
