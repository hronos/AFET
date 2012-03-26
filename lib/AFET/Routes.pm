package AFET::Routes;

# All URLS are defined in this module

use Dancer ':syntax';
use strict;
use warnings;
use Dancer::Config;
use AFET;
use Data::Dumper;

get '/army' => sub {
    template 'army',;    # serve army template
};
get '/army/custom' => sub {
    template 'army_custom',;    # serve army template
};
get '/navy' => sub {
    template 'navy',;    # serve navy template
};
get '/raf' => sub {
    template 'raf',;     # serve raf template
};
get '/profile' => sub {
    template 'profile',;     # serve raf template
};
get '/manual' => sub {
    template 'user_manual',;     # serve raf template
};
get '/contact' => sub {
    template 'contact',;     # serve raf template
};

# Generate custom tests for each service

post '/test/generate/custom/:service' => sub {
    my $service = param('service');
    my $params = params;
    print Dumper ($params);
    template 'test',;
};

# Generate test according to service
get '/test/generate/:service' => sub {
    my $service = param('service');                                         # Service parameter is passed in url
    debug "SERVICE1 ======" . $service;                                     # Output service to console log for troubleshooting
    my ( $nonverb, $verb, $num, $mech ) = AFET::Test->generate($service);   # Call AFET::Test class, method "generate" to generate actual questions
    template 'test',    # Template for test page
      {                 # Pass variables to template
        'service' => $service,
        'nonverb' => $nonverb,
        'verb'    => $verb,
        'num'     => $num,
        'mech'    => $mech
      };
};

# Timed test is different
get '/test/generate/timed/:service' => sub {
    my $service    = param('service');                                      # get service variable from url
    my $start_time = AFET::Timer->start;                                    # Call AFET::Timer class method "start"
    my ( $nonverb, $verb, $num, $mech ) = AFET::Test->generate($service);   #Call AFET::Test class, method "generate" to generate actual questions
    template 'test',    # we use the same template as for non timed test
      {                 # passing variables to template
        'service'    => $service,
        'nonverb'    => $nonverb,
        'verb'       => $verb,
        'num'        => $num,
        'mech'       => $mech,
        'start_time' => $start_time
      };
};

# Category test

get '/test/generate/nonverb/:service' => sub {
    my $service = param('service');                                         # Service parameter is passed in url
    my ( $nonverb, $verb, $num, $mech ) = AFET::Test->generate($service);   # Call AFET::Test class, method "generate" to generate actual questions
    template 'test_cat',    # Template for test page
      {                 # Pass variables to template
        'service' => $service,
        'nonverb' => $nonverb,
      };
};
get '/test/generate/verb/:service' => sub {
    my $service = param('service');                                         # Service parameter is passed in url
    my ( $nonverb, $verb, $num, $mech ) = AFET::Test->generate($service);   # Call AFET::Test class, method "generate" to generate actual questions
    template 'test_cat',    # Template for test page
      {                 # Pass variables to template
        'service' => $service,
        'verb' => $verb,
      };
};
get '/test/generate/num/:service' => sub {
    my $service = param('service');                                         # Service parameter is passed in url
    my ( $nonverb, $verb, $num, $mech ) = AFET::Test->generate($service);   # Call AFET::Test class, method "generate" to generate actual questions
    template 'test_cat',    # Template for test page
      {                 # Pass variables to template
        'service' => $service,
        'num' => $num,
      };
};
get '/test/generate/mech/:service' => sub {
    my $service = param('service');                                         # Service parameter is passed in url
    my ( $nonverb, $verb, $num, $mech ) = AFET::Test->generate($service);   # Call AFET::Test class, method "generate" to generate actual questions
    template 'test_cat',    # Template for test page
      {                 # Pass variables to template
        'service' => $service,
        'mech' => $mech,
      };
};

# Check answers
post '/test/check_answers' => sub {
    # Call AFET::Test class method check_answers to check answers user has given and save subcategories in which user has made mistakes.
    my ( $result, $wrong_subcats ) = AFET::Test->check_answers();
    # Split subcat list we got from  AFET::Test->check_answers into individual subcategories
    $wrong_subcats =~ s/([[:upper:]])/:$1/g; 
    my $start_time = params->{start_time};                  # Get timer start time from page to see if test was timed.
    my $time_taken;                                         # Initialise variable for time user taken to do the test
    if ($start_time)
    {                                                       # If test was time this variable should exist, otherwise don't bother
        $time_taken = AFET::Timer->stop($start_time);       # Call Class AFET::Timer method stop to stop timer and get time
        $time_taken = AFET::Timer->human_sec($time_taken);  # Convert time taken to human readable form by calling method human_sec from Class AFET::Timer
    }
    my $service = params->{service};
    template 'result',                                      # set template and pass variables to it
      {
        'result'     => $result,
        'wrong_subs' => $wrong_subcats,
        'time_taken' => $time_taken,
        'service'    => $service,
      };
};

