# User authentication and sessions handling
package AFET::Auth;

use Dancer ':syntax';
use strict;
use warnings;
use Dancer::Plugin::Database;
use Dancer::Config;
use Dancer::Plugin::Passphrase;
use Dancer::Plugin::Ajax;

#use AFET;

# Login page

any [ 'get', 'post' ] => '/login' => sub {
    my $err;    # Used to display errors

    if ( request->method() eq "POST" ) {

        my $user =
          database->quick_select(    # Get user login details from database
            'users',
            { username => params->{'username'},
            }                        # select row with matching username
          );
        if ( !defined $user->{username} ) {    # If no such user exists
            warning "Failed login, user not recognized "
              . params->{'username'};          # Log failed attempt and username
            $err = "Login Failed";    # Let the user know that login failed
        }
        else {                        # If user exists
            if (
                passphrase( params->{'password'} )->matches( $user->{'pass'} ) )
            {    # Check if password entered matches stored hash
                session 'logged_in' => true;    # set session
                return redirect '/';            # Redirect to main page
            }
            else {                              # password didn't match
                warning "Failed login, password did not match "
                  . params->{'password'};    # Log failed attempts and password
                $err = "Login failed";    # Let the user know that login failed
            }
        }

    }

    # render login form
    template 'login.tt', { 'err' => $err, };
};

# Logout page

get '/logout' => sub {
    session->destroy;    # destroy session
    redirect '/';        # redirect to main page
};

# Registration

get '/register' => sub {
    template 'register',;    # render registration template
};

post '/register/new' => sub {    # Register new user
                                 # Get parameters from template
    my $username = params->{username} or die "missing parameter";
    my $pass = passphrase( params->{pass} )->generate_hash
      or die "missing parameter";
    my $email    = params->{email}    or die "missing parameter";
    my $id_roles = params->{id_roles} or die "missing parameter";

    # Quick insert to DB
    database->quick_insert(
        'users',
        {
            username => $username,
            pass     => $pass,
            email    => $email,
            id_roles => $id_roles,
        }
    );
    redirect '/login';    # redirect new user to login page
};
