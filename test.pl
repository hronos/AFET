#!/usr/bin/perl

use strict;
use warnings;

sub generate_name {
    my $name;
    my $length = shift;
    my @chars = ('a'..'z', 'A'..'Z', '0'..'9', '_');
    foreach (1..$length) {
        $name.=$chars[rand @chars];
    }
    return $name;
}

my $filename = generate_name(15);
$filename = "$filename\.png";
print "$filename\n";
