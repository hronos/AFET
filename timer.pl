#!/usr/bin/perl

use strict;
use warnings;
print "Enter to start\n";
my $useless_var = <>;
my $start = time;
print "hit Enter to stop\n";
$useless_var = <>;
my $stop = time;
my $seconds = $stop - $start;
print "Seconds: $seconds\n";

