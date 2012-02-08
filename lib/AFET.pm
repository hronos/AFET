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
    my $dbh = database()
      or die $DBI::errstr;
    return $dbh;
}

my $flash;

sub set_flash {
    my $message = shift;
    $flash = $message;
}

before_template sub {
   my $tokens = shift;
       
   $tokens->{'css_url'} = request->base . 'css/style.css';
   $tokens->{'login_url'} = uri_for('/login');
   $tokens->{'logout_url'} = uri_for('/logout');
};

true;
