package AFET::Routes;

use Dancer ':syntax';
use strict;
use warnings;
use Dancer::Config;
use AFET;

get '/army' => sub {
    template 'army',;
};
get '/navy' => sub {
    template 'navy',;
};
get '/raf' => sub {
    template 'raf',;
};

