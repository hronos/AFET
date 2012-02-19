# Subs common across application
package AFET;
use Dancer ':syntax';
use strict;
use warnings;
use Dancer::Plugin::Database;
use Dancer::Plugin::SimpleCRUD;
use Dancer::Config;

our $VERSION = '0.1';
# Index page
get '/' => sub {
    template 'index';
};

# Database connection initialised here
sub connect_db {
    my $dbh = database()
      or die $DBI::errstr;
    return $dbh;
}

# Settings common for all templates can be set here

before_template sub {
    my $tokens = shift;
    # Set urls
    $tokens->{'login_url'}  = uri_for('/login'); # Login url
    $tokens->{'logout_url'} = uri_for('/logout'); # Logout url
    $tokens->{'register_url'} = uri_for('/register'); # Register url
};

true;
