#!/usr/bin/env perl

$setupfile="setup.ini";
unless (open(SETUP, $setupfile)) {
    die "$0: could not open $setupfile";
}

# Read setup.ini a record at a time, printing the descriptions of all
# the base packages. Surprisingly, even though the format of setup.ini
# seems to be paragraph-oriented, blank lines are allowed within a record.

$/ = "";                                 # Paragraph mode

# Prime the pump: read and write the header
# and then the start of the first record.
$_ = <SETUP>;
print;
$_ = <SETUP>;

do {
    $record = $_;

    # Read the next paragraph. Loop until we find a new record.
    do {
        $_ = <SETUP>;
        if ( !m/^\@/ ) {
            $record = $record . $_;
        }
    } while ( !m/^\@/ && !eof SETUP );

    if  ( $record =~ /category:.*Base/ ) {
        print "$record";
    }
} while ( !eof SETUP );

# Currently, we're skipping the last record unless it's
# a continuation of the previous record.

# Local Variables:
# indent-tabs-mode: nil
# End:
