package AFET::Testmod;

use Dancer ':syntax';
use strict;
use warnings;
use Dancer::Plugin::Database;
use Dancer::Plugin::SimpleCRUD;
use Dancer::Config;
use Dancer::Request::Upload;
use Dancer::Request;
use Dancer::Plugin::Ajax;
use Dancer::Plugin::ValidateTiny;

#use AFET;

use Data::Dumper;

my $label = "no label";
my $err;
get '/testmod' => sub {
    $label = "no label";
    template 'testmod' => { label => $label };

};


post '/testmod/upload' => sub {
    my $file = upload('filename');
    debug "TEST ====>" . ref($file);
    my $fh = $file->file_handle;
    debug "TEST FH ===>" . $fh;
    my $content = $file->content;
    debug "TEST CONT ====> " . $content;
};

post '/testmod/test_ajax' => sub {
    my $username = params->{'username'};
    my $password = params->{'password'};
    debug "USERNAME ======>" . params->{'username'};
    debug "PASSWORD ======>" . params->{'password'};
    if ( $username ne "test" && $password ne "password" ) {
        $label = "Login failed";
    }
    else {
        $label = "Login successful";
    }
    template 'testmod' => { label => $label };
};

post '/testmod/test_user' => sub {
    my $params = params;
    my $valid  = 0;
    my $result   = validator( $params, 'register.pl' );
    if ( $result->{valid} ) {
        my $username = $result->data('usr');
        my $password = $result->data('pwd');
        my $exists   = check_username_exist($username);
        debug "EXISTS VAR =============>  : " . $exists;
        if ( $exists == '1' ) {
            $label = "user exists!";
        }
        else {
            $label = "user OK";
        }
        template 'testmod' => { label => $label };
    }
    else {
        my $errors_hash = $result->error;
        #print Dumper ($errors_hash);
        my $err_user = $result->error('usr');
        my $err_pwd =  $result->error('pwd');
        my $err_pwd2 = $result->error('pwd2');
        template 'testmod' => {
            err_user => $err_user,
            err_pwd  => $err_pwd,
            err_pwd2 => $err_pwd2,
        };
       
    }
};

sub check_username_exist {
    my $arg = shift;
    debug "arg VAR =============>  : " . $arg;
    my $user = database->quick_select( 'users', { username => $arg, } );
    if ( defined $user->{username} ) {
        debug "INSIDE DEFINED ";
        return true;
    }
    else {
        debug "INSIDE ELSE";
        return false;
    }
}
