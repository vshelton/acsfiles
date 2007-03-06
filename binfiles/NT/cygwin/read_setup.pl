#!/usr/bin/env perl

# Print the specified record from setup.ini.

$pkgname = shift @ARGV || die "$0: not enough arguments";
# Make the + in g++ not special when it's used in pattern matching later.
$pkgname =~ s'\+'\\+'g;
#print "pkgname = $pkgname\n";

$setupfile="setup.ini";
unless (open(SETUP, $setupfile)) {
    die "$0: could not open $setupfile";
}

# Read setup.ini a line at a time, looking for the requested package.
# When we find the requested package, read and print the record
# until the start of the next record or the end of the file is reached.
while ( <SETUP> ) {
    if ( /^\@\s*$pkgname\n/ ) {
        print;
        while ( <SETUP> ) {
            if ( /^\@/ ) {
                goto done;
            }
            print;
        }
    }
}

done:

# Local Variables:
# indent-tabs-mode: nil
# End:
