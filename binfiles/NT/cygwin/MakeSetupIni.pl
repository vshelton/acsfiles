#!/usr/bin/env perl

# Make a Cygwin kit suitable for burning onto a CD.

#---------------------------------------------------------
# Extract the package information from the setup.ini file.
#---------------------------------------------------------

$setupfile="setup.ini";
unless (open(SETUP, $setupfile)) {
    die "$0: could not open $setupfile";
}

$/ = "";                                 # Paragraph mode

# Save the setup.ini header.
$setup_header = <SETUP>;

# Read setup.ini one record at a time. Surprisingly, even though
# the format of setup.ini seems to be paragraph-oriented,
# blank lines are allowed within a record.
$next_record = <SETUP>;
while ( $next_record ) {

    # Read until the start of the next record
    $record = $next_record;
    $next_record = <SETUP>;
    while ( !eof SETUP && ($next_record !~ m/^@ /) ) {
        $record = $record . $next_record;
        $next_record = <SETUP>;
    }
    chop $record;

#print "Record =\n$record\nEnd of Record\n";
    ($pkg) = ($record =~ /^@ (.*)\nsdesc: (.*)\n/);

    # Split package info into cur, prev and test sections.
    ($cur, $prev) = split /\n\[prev\]/, $record;
    if ( $prev ) {
        ($prev, $test) = split /\n\[test\]/, $prev;
    } else {
        ($cur, $test) = split /\n\[test\]/, $record;
    }
#print "cur = $cur\n" if $cur;
#print "\nprev = $prev\n" if $prev;
#print "\ntest = $test\n" if $test;
    # sdescs can be more than one line long, and there
    # a record doesn't need to have an ldesc.
    ($sdesc{$pkg}) = ($cur =~ /sdesc: (.*)\nldesc/s);
    if ( $sdesc{$pkg} eq "" ) {
        ($sdesc{$pkg}) = ($cur =~ /sdesc: (.*)\n/);
    }
    ($ldesc{$pkg}) = ($cur =~ /\nldesc: (.*)\ncategory:/s);
    ($category{$pkg}) = ($cur =~ /\ncategory: (.*)/);
    ($requires{$pkg}) = ($cur =~ /\nrequires: (.*)/);
    ($version{$pkg}) = ($cur =~ /\nversion: (.*)/);
    ($install{$pkg}) = ($cur =~ /\ninstall: (.*)/);
    ($source{$pkg}) = ($cur =~ /\nsource: (.*)/);
    if ( $prev ) {
        ($prev_version{$pkg}) = ($prev =~ /\nversion: (.*)/);
        ($prev_install{$pkg}) = ($prev =~ /\ninstall: (.*)/);
        ($prev_source{$pkg}) = ($prev =~ /\nsource: (.*)/);
    }
    if ( $test ) {
        ($test_version{$pkg}) = ($test =~ /\nversion: (.*)/);
        ($test_install{$pkg}) = ($test =~ /\ninstall: (.*)/);
        ($test_source{$pkg}) = ($test =~ /\nsource: (.*)/);
    }
}
close SETUP;
rename $setupfile, "$setupfile.bak";

if ( 0 ) {
foreach $pkg (sort keys %sdesc) {
    print "\n@ $pkg\n";
    print "sdesc: $sdesc{$pkg}\n";
    print "ldesc: $ldesc{$pkg}\n" if $ldesc{$pkg};
    print "category: $category{$pkg}\n" if $category{$pkg};
    print "requires: $requires{$pkg}\n" if $requires{$pkg};
    print "version: $version{$pkg}\n" if $version{$pkg};
    print "install: $install{$pkg}\n" if $install{$pkg};
    print "source: $source{$pkg}\n" if $source{$pkg};
    if ( $prev_version{$pkg} || $prev_install{$pkg} || $prev_source{$pkg} ) {
        print "[prev]\n";
        print "version: $prev_version{$pkg}\n" if $prev_version{$pkg};
        print "install: $prev_install{$pkg}\n" if $prev_install{$pkg};
        print "source: $prev_source{$pkg}\n" if $prev_source{$pkg};
    }
    if ( $test_version{$pkg} || $test_install{$pkg} || $test_source{$pkg} ) {
        print "[test]\n";
        print "version: $test_version{$pkg}\n" if $test_version{$pkg};
        print "install: $test_install{$pkg}\n" if $test_install{$pkg};
        print "source: $test_source{$pkg}\n" if $test_source{$pkg};
    }
}
}

#----------------------------------------------------------------------------
# Create a package list from the list of base packages found in the setup.ini
# file and add the names of all the user-specified extra packages.
#----------------------------------------------------------------------------

foreach $pkg ( keys %sdesc) {
    $package_list{$pkg} = 1 if ($category{$pkg} =~ m/\bbase\b/i);
}

if ( $ENV{"extra_packages"} ) {
    foreach $pkg ( split /\s+/, $ENV{"extra_packages"} ) {
        $package_list{$pkg} = 1;
    }
} else {
    if ( open EXTRA, "extra_packages" ) {
        $extra_packages = <EXTRA>;
        close EXTRA;
        foreach $pkg ( split /\s+/, ($extra_packages)) {
            $package_list{$pkg} = 1;
        }
    }
}

#--------------------------------------------------------------------------
# Add to the package list the names of all the packages required by already
# in the package list.  Repeat until the list of packages doesn't change.
#--------------------------------------------------------------------------

undef %prev_package_list;
while ( %prev_package_list ne %package_list ) {
    %prev_package_list = %package_list;
    foreach $pkg ( keys %prev_package_list ) {
        foreach $p ( split /\s+/, $requires{$pkg} ) {
            $package_list{$p} = 1;
        }
    }
}

#----------------------------------------------------------------------
# Make all the packages in the package list required by one of the Base
# packages.  This will make all the packages get installed by default
# when setup is run.
#----------------------------------------------------------------------

$master_pkg="_update-info-dir";
$requires{$master_pkg} = sort keys %package_list;

#---------------------------------------------------------------
# Write out a new setup.ini file, comprised only of the packages
# in the package list.
#---------------------------------------------------------------

open STDOUT, "> $setupfile";
print $setup_header;
foreach $pkg (sort keys %package_list) {
    print "\n@ $pkg\n";
    print "sdesc: $sdesc{$pkg}\n";
    print "ldesc: $ldesc{$pkg}\n" if $ldesc{$pkg};
    print "category: $category{$pkg}\n" if $category{$pkg};
    print "requires: $requires{$pkg}\n" if $requires{$pkg};
    print "version: $version{$pkg}\n" if $version{$pkg};
    print "install: $install{$pkg}\n" if $install{$pkg};
    print "source: $source{$pkg}\n" if $source{$pkg};
    if ( $prev_version{$pkg} || $prev_install{$pkg} || $prev_source{$pkg} ) {
        print "[prev]\n";
        print "version: $prev_version{$pkg}\n" if $prev_version{$pkg};
        print "install: $prev_install{$pkg}\n" if $prev_install{$pkg};
        print "source: $prev_source{$pkg}\n" if $prev_source{$pkg};
    }
    if ( $test_version{$pkg} || $test_install{$pkg} || $test_source{$pkg} ) {
        print "[test]\n";
        print "version: $test_version{$pkg}\n" if $test_version{$pkg};
        print "install: $test_install{$pkg}\n" if $test_install{$pkg};
        print "source: $test_source{$pkg}\n" if $test_source{$pkg};
    }
}

# Local Variables:
# indent-tabs-mode: nil
# End:
