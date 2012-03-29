package AFET::Custom;

# package to deal with custom tests

use Dancer ':syntax';
use strict;
use warnings;
use Dancer::Plugin::Database;
use Dancer::Config;
use Data::Dumper;

# Method to list custom tests
sub list {
    my $uid = $_[1];                 # get parameters
    my $db  = AFET::connect_db();    # connect to database
    my $sql =
      "SELECT id_test, subcat_array FROM custom_test where id_user = $uid"
      ;                              # prepare sql
    my $sth = $db->prepare($sql) or die $db->errstr;
    $sth->execute() or die $sth->errstr;
    my $custom_tests =
      $sth->fetchall_arrayref( {} );    # get array of custom tests
    return $custom_tests;
}

# Method to list results

sub list_results {
    my $uid = $_[1];                    # getting arguments
    my $db  = AFET::connect_db();       # db connection
    my $sql =
"SELECT id_result, time_taken, ans_ratio, date FROM results where id_user = $uid"
      ;                                 # sql
    my $sth = $db->prepare($sql) or die $db->errstr;
    $sth->execute() or die $sth->errstr;
    my $results = $sth->fetchall_arrayref( {} );    # get results array
    return $results;
}

# Method to load custom tests
sub load {
    my $sub_ids = $_[1];                            # arguments
    my $sql =
"SELECT id_quest, quest_text, ans_a, ans_b, ans_c, ans_d, right_ans, img, id_subcat FROM questions where id_subcat in ($sub_ids) ORDER BY RANDOM() LIMIT 20";
    my $custom = AFET::Test::get_questions($sql);   # Call AFET::Test class, method get_questions to select questions hash
    return $custom;
}

true;

