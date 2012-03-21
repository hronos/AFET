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

get '/test/generate/:service' => sub {
    my $service = param('service');
    debug "SERVICE1 ======" . $service;
    my ($nonverb, $verb, $num, $mech ) = AFET::Test->generate($service);
    template 'test',
    {'service' => $service, 'nonverb' => $nonverb, 'verb' => $verb, 'num' => $num, 'mech' => $mech};
};

post '/test/check_answers' => sub {
    
    my ( $result, $wrong_subcats) = AFET::Test->check_answers();
    #print Dumper ($unique_subs);
    debug "SUBS ======>" . $wrong_subcats;
    template 'result',
    {'result' => $result, 'wrong_subs' => $wrong_subcats};
};

