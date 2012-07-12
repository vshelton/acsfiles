
# Save a record of this session
outfile=$HOME/.hist/$(date '+%Y-%m-%d-%H%M').${HOST%%.*}
[[ -e $outfile ]] && chmod 600 $outfile

# Get the date and time of the first command in the shell history.
fc -lin -$HISTSIZE | read d t cmd

# Ignore all commands that have the same date and time.
# They were read in when the shell started.
fc -lin -$HISTSIZE | grep -v "^$d $t" >> $outfile
if [[ -s $outfile ]]; then
  chmod 400 $outfile
  [[ $UID = 0 ]] && chmod 440 $outfile
else
   rm -f $outfile
fi

# Local Variables:
# mode: shell-script
# sh-indentation: 2
# indent-tabs-mode: nil
# End:
