#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;


my %hash;
my @machines=("server01","server02","server03");
my @serials=("1111","2222","3333");

@hash{@machines}=@serials;

if (exists $hash{$ARGV[0]}) {
    print "Value for $ARGV[0] is: $hash{$ARGV[0]}\n";
}else {
    print "$ARGV[0] Not found!\n";
}
print Dumper(%hash);
