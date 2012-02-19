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

#use AFET;

use Data::Dumper;

my $label = "no label";
get '/testmod' => sub {
    template 'testmod' => {label => $label};
};

post '/testmod/upload' => sub {
    my $file = upload('filename');
    debug "TEST ====>" . ref ($file);
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
    if ($username ne "test" && $password ne "password" ){
        $label = "Login failed";
    }else {
        $label = "Login successful";
    }
    template 'testmod'  => {label => $label};
};
