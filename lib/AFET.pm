package AFET;
use Dancer ':syntax';
use strict;
use warnings;
use Dancer::Plugin::Database;
use Dancer::Plugin::SimpleCRUD;
use Dancer::Config;
#use AFET::DB;

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

sub connect_db {
    my $dbh = database() or
    die $DBI::errstr;
    return $dbh;
}

true;
