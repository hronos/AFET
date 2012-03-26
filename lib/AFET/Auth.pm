# User authentication and sessions handling
package AFET::Auth;

use Dancer ':syntax';
use strict;
use warnings;
use Dancer::Plugin::Database;
use Dancer::Config;
use Dancer::Plugin::Passphrase;
use Dancer::Plugin::ValidateTiny;
use Data::Dumper;

#use AFET;

# Login page

any [ 'get', 'post' ] => '/login' => sub {
    my $err;    # Used to display errors

    if ( request->method() eq "POST" ) {

        my $user = database->quick_select(    # Get user login details from database
            'users',
            { username => params->{'username'},} # select row with matching username
          );
        my $user_id = $user->{id_user};         # Get user id to use in session
        if ( !defined $user->{username} ) {    # If no such user exists
            warning "Failed login, user not recognized ";
              debug "USER ->> ". params->{'username'};          # Log failed attempt and username
            $err = "Log in Failed";    # Let the user know that login failed
        }
        else {                        # If user exists
            if (
                passphrase( params->{'password'} )->matches( $user->{'pass'} ) )
            {    # Check if password entered matches stored hash
                session 'logged_in' => true;                # set session true
                session 'user_id'   => $user_id;            # Store user id
                session 'username'  => $user->{username};   # Store username
               
                return redirect '/';            # Redirect to main page
            }
            else {                              # password didn't match
                warning "Failed login, password did not match " . params->{'password'};    # Log failed attempts and password
                $err = "Log in failed";    # Let the user know that login failed
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
    my $label = "no label";
    my $params = params;
    my $valid = 0;
    my $result = validator( $params, 'register.pl' );
    $valid = $result->success;
    if ($valid == 1) {
        debug "INSIDE IF - result-valid" . $result;
        my $username = $result->data('usr');
        my $password = $result->data('pwd');
        my $exists = check_username_exist($username);
        if ( $exists == '1' ) {
            debug "user exists";
            $label = "user exists!";
        } else {
            debug "INSIDE ELSE - ADDING user";
            $label = "user OK";
            my $username = params->{usr} or die "missing parameter";
            my $pass = passphrase( params->{'pwd'} )->generate_hash;
            my $email    = params->{'email'};
            my $id_roles = params->{'id_roles'} or die "missing parameter";
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
        }
        template 'register' => { label => $label };
    } 
    else {
        my $errors_hash = $result->error;
        my $err_user = $result->error('usr');
        my $err_pwd = $result->error('pwd');
        my $err_pwd2 = $result->error('pwd2');
        my $err_email = $result->error('email');
        template 'register' => {
            err_user => $err_user,
            err_pwd => $err_pwd,
            err_pwd2 => $err_pwd2,
            err_email => $err_email,
        };
    }    
};

sub check_username_exist {
    my $arg = shift;
    my $user = database->quick_select( 'users', { username => $arg, } );
    if ( defined $user->{username} ) {
        return true;
    }
    else {
        return false;
    }
}


