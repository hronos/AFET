package AFET::Routes;

# All URLS are defined in this module

use Dancer ':syntax';
use strict;
use warnings;
use Dancer::Config;
use AFET;
use Dancer::Plugin::Database;
use Data::Dumper;

get '/army' => sub {
    template 'army',;    # serve army template
};
get '/army/custom' => sub {
    template 'army_custom',;    # serve army custom template
};
get '/navy' => sub {
    template 'navy',;    # serve navy template
};
get '/navy/custom' => sub {
    template 'navy_custom',;    # serve navy custom template
};
get '/raf' => sub {
    template 'raf',;     # serve raf template
};
get '/raf/custom' => sub {
    template 'raf_custom',;    # serve raf custom template
};
get '/profile' => sub {    # profile
    my $uid = session 'user_id';  # get user id from session
    my $custom_tests;   
    my $results;
    if ($uid){      # if user logged in
        $custom_tests = AFET::Custom->list($uid); #get saved custom tests
        $results = AFET::Custom->list_results($uid); # get saved results
    }
    template 'profile', {'custom_tests' => $custom_tests, 'results' => $results }     # profile template variables
};
get '/manual' => sub {
    template 'user_manual',;     # serve manual template
};
get '/contact' => sub {
    template 'contact',;     # serve contact template
};
get '/contact/sent' => sub {
    template 'contact_sent',;     # serve contact sent page
};

# Generate custom tests for each service

post '/test/generate/custom/:service' => sub { # action to generate custom test
    my $service = param('service');
    my %params = params;
    my @sub_ids;
    foreach my $val (values (%params)){ # create array of chosen subcategories
        if ($val ne $service){
            push (@sub_ids, $val);
        }
    }
    my $sub_ids = join (',', @sub_ids); # delimit sub_ids by comma
    my $sql = "SELECT id_quest, quest_text, ans_a, ans_b, ans_c, ans_d, right_ans, img, id_subcat FROM questions where id_subcat in ($sub_ids) ORDER BY RANDOM() LIMIT 20"; # prepare sql
    my $custom = AFET::Test::get_questions($sql); # call get_questions method 
    template 'test_custom', { 'custom' => $custom, 'is_custom' => '1', 'sub_ids' => $sub_ids }; # pass questions to template
};

# Load saved custom test action
get '/test/load/custom/:testid' => sub {
    my $test_id = param('testid');
    my $db_row = database->quick_select( 'custom_test', { id_test => $test_id }); # select by id
    my $sub_ids = $db_row->{subcat_array}; # we need only subcategories
    my $custom = AFET::Custom->load($sub_ids); # call load method from AFET::Custom
    template 'test_custom', { 'custom' => $custom, 'is_custom' => '1', 'sub_ids' => $sub_ids }; # pass variables to template
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
    my $is_custom = params->{'is_custom'};                              # To see if that was custom test
    my $sub_ids = params->{'sub_ids'};                                  # To save later if that was custom test
    my $service = params->{service};
    template 'result',                                      # set template and pass variables to it
      {
        'result'     => $result,
        'wrong_subs' => $wrong_subcats,
        'time_taken' => $time_taken,
        'service'    => $service,
        'is_custom'  => $is_custom,
        'sub_ids'    => $sub_ids,
      };
};

# Action to save custom test
post '/test/save' => sub {
    my $uid = params->{'user_id'}; # we need user id
    my $sub_ids = params->{'sub_ids'}; # and subcategories chosen
    database->quick_insert( # insert all into DB
        'custom_test',
        {
            id_user         => $uid,
            subcat_array    => $sub_ids,
        }
    );
    redirect '/profile'; # and redirect to profile
};

# Action to save results

post '/test/save/result' => sub { 
    my $params = params; # getting all parameters from form
    my $uid = params->{'user_id'};
    my $result = params->{'result'};
    my $time_taken = params->{'time_taken'};
    my $time = time; # generate time
    my $date = scalar localtime($time); # time to human readable format
    database->quick_insert( # Insert to database
        'results',
        {
            id_user => $uid,
            time_taken => $time_taken,
            ans_ratio => $result,
            date    => $date,
        }
    );
    redirect '/profile'; # and redirect to profile
};
