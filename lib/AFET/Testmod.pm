package AFET::Testmod;

use Dancer ':syntax';
use strict;
use warnings;
use Dancer::Plugin::Database;
use Dancer::Plugin::SimpleCRUD;
use Dancer::Config;
use Dancer::Request::Upload;
use Dancer::Request;

#use AFET;

use Data::Dumper;

get '/testmod' => sub {
    template 'testmod';
};

post '/testmod/upload' => sub {
    my $file = upload('filename');
    debug "TEST ====>" . ref ($file);
    my $fh = $file->file_handle;
    debug "TEST FH ===>" . $fh;
    my $content = $file->content;
    debug "TEST CONT ====> " . $content;
};
