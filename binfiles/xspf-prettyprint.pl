#!/usr/bin/env perl

use strict;
use File::Copy;
use XML::XSPF;
use XML::XSPF::Track;

foreach my $filename (@ARGV) {

    # Parse the source .xspf file.
    my $playlist = XML::XSPF->parse($filename);

    # Save a backup copy of the original .xspf file
    # and open the original file for writing.
    move($filename, $filename . ".orig") or die "Move failed: $!";
    open(my $fh, ">", $filename) or die "Cannot write $filename: $!";

    # Write pre-amble.
    print $fh '<?xml version="1.0" encoding="UTF-8"?>
<playlist version="1" xmlns="http://xspf.org/ns/0/">
<trackList>
';

    for my $track ($playlist->trackList) {
        if ($track->title) {
            print $fh "    <track>\n";
            print $fh "      <title>"    . $track->title    . "</title>\n";
            print $fh "      <creator>"  . $track->creator  . "</creator>\n";
            print $fh "      <album>"    . $track->album    . "</album>\n";
            print $fh "      <location>" . $track->location . "</location>\n";
            print $fh "      <duration>" . $track->duration . "</duration>\n";
            print $fh "      <trackNum>" . $track->trackNum . "</trackNum>\n";
            print $fh "    </track>\n";
        }
    }

    # Write closing statement.
    print $fh "  </trackList>\n</playlist>\n";
}

