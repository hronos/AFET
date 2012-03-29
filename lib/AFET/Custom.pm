package AFET::Custom;
# package to deal with custom tests

use Dancer ':syntax';
use strict;
use warnings;
use Dancer::Plugin::Database;
use Dancer::Config;
use Data::Dumper;

sub list {
    my $uid = $_[1];
    my $db = AFET::connect_db();
    my $sql = "SELECT id_test, subcat_array FROM custom_test where id_user = $uid";
    #print Dumper ($sql);
    my $sth = $db->prepare($sql) or die $db->errstr;
    $sth->execute() or die $sth->errstr;
    my $custom_tests =  $sth->fetchall_arrayref( {} );
    return $custom_tests;
}

sub load {
    my $sub_ids = $_[1];
    my $sql = "SELECT id_quest, quest_text, ans_a, ans_b, ans_c, ans_d, right_ans, img, id_subcat FROM questions where id_subcat in ($sub_ids) ORDER BY RANDOM() LIMIT 20";
    my $custom = AFET::Test::get_questions($sql);
    return $custom;
};

true;

