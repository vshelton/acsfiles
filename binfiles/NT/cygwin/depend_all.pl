#!/usr/bin/env perl

# Modify stdin so one package depends on all the other named packages.

$/ = "";                                 # Paragraph mode
$master_pkg=shift;

while ( <STDIN> ) {
    s/(@\s*$master_pkg\nsdesc:.*\ncategory:.*\nrequires:).*/\1 @ARGV/;
    print;
}

# Local Variables:
# indent-tabs-mode: nil
# End:

