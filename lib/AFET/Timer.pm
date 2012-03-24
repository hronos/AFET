package AFET::Timer;

# Timer class for timed tests

use Dancer ':syntax';
use strict;
use warnings;
use Dancer::Config;
use Data::Dumper;

# Timer methods

# Start timer
sub start {
    my $start_time = time;    # set start time
    return $start_time;
}

# Stop timer
sub stop {
    my $start_time  = $_[1];                    # get arguments passed to method
    my $end_time    = time;                     # stop timer and record time
    my $seconds_run = $end_time - $start_time;  # find seconds since start time
    return $seconds_run;
}

# Convert seconds to human readable format
sub human_sec {
    my $time  = $_[1];                          # Get arguments passed to method
    my $hours = int( $time / 3600 );            # Extract hours
    my $mins  = int( $time / 60 );              # extract minutes
    my $secs  = $time % 60;                     # All what's left is seconds
    $hours = $hours < 1 ? '' : $hours . 'h ';   # Formatting
    $mins  = $mins < 1  ? '' : $mins . 'm ';    # Formatting
    $time = $hours . $mins . $secs . 's';       # Formatting
    return $time;
}

true;
