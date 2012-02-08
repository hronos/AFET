# User authentication and sessions handling
package AFET::Auth;

use Dancer ':syntax';
use strict;
use warnings;
use Dancer::Plugin::Database;
use Dancer::Config;
use AFET;


# Login page

any [ 'get', 'post' ] => '/login' => sub {
    my $err;

    if ( request->method() eq "POST" ) {

        # process form input
        if ( params->{'username'} ne setting('username') ) {
            $err = "Invalid username";
        }
        elsif ( params->{'password'} ne setting('password') ) {
            $err = "Invalid password";
        }
        else {
            session 'logged_in' => true;
            return redirect '/';
        }
    }

    # render login form
    template 'login.tt', { 'err' => $err, };
};

# Logout page

get '/logout' => sub {
   session->destroy;
   redirect '/';
};
