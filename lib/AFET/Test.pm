package AFET::Test;

use Dancer ':syntax';
use strict;
use warnings;
use Dancer::Config;
use Dancer::Plugin::Database;
use Data::Dumper;

my $db = AFET->connect_db();
my $sql;
my $sth;
my $army_nonverb = 'SELECT id_quest, quest_text, ans_a, ans_b, ans_c, ans_d, right_ans, img FROM questions where id_subcat = 1 OR id_subcat = 2 ORDER BY RANDOM() LIMIT 20';
my $army_verb = 'SELECT id_quest, quest_text, ans_a, ans_b, ans_c, ans_d, right_ans, img FROM questions where id_subcat = 5 OR id_subcat = 6 OR id_subcat = 8 ORDER BY RANDOM() LIMIT 20';
my $army_num = 'SELECT id_quest, quest_text, ans_a, ans_b, ans_c, ans_d, right_ans, img FROM questions where id_subcat = 29 OR id_subcat = 20  OR id_subcat = 24 OR id_subcat = 25 ORDER BY RANDOM() LIMIT 20';

my $navy_nonverb = 'SELECT id_quest, quest_text, ans_a, ans_b, ans_c, ans_d, right_ans, img FROM questions where id_subcat = 2 OR id_subcat = 4 ORDER BY RANDOM() LIMIT 20';
my $navy_verb = 'SELECT id_quest, quest_text, ans_a, ans_b, ans_c, ans_d, right_ans, img FROM questions where id_subcat = 5 OR id_subcat = 8 OR id_subcat = 9 OR id_subcat = 10 OR id_subcat = 11 OR id_subcat = 12 ORDER BY RANDOM() LIMIT 20';
my $navy_num = 'SELECT id_quest, quest_text, ans_a, ans_b, ans_c, ans_d, right_ans, img FROM questions where id_subcat = 20 OR id_subcat = 22  OR id_subcat = 23 OR id_subcat = 24 OR id_subcat = 25 OR id_subcat = 26 OR id_subcat = 27 ORDER BY RANDOM() LIMIT 20';
my $navy_mech = 'SELECT id_quest, quest_text, ans_a, ans_b, ans_c, ans_d, right_ans, img FROM questions where id_subcat = 13 OR id_subcat = 14  OR id_subcat = 15 OR id_subcat = 16 OR id_subcat = 17 OR id_subcat = 18 ORDER BY RANDOM() LIMIT 20';

my $raf_nonverb = 'SELECT id_quest, quest_text, ans_a, ans_b, ans_c, ans_d, right_ans, img FROM questions where id_subcat = 2 OR id_subcat = 2 OR id_subcat = 3 ORDER BY RANDOM() LIMIT 20';
my $raf_verb = 'SELECT id_quest, quest_text, ans_a, ans_b, ans_c, ans_d, right_ans, img FROM questions where id_subcat = 8 OR id_subcat = 11 OR id_subcat = 4 ORDER BY RANDOM() LIMIT 20';
my $raf_num = 'SELECT id_quest, quest_text, ans_a, ans_b, ans_c, ans_d, right_ans, img FROM questions where id_subcat = 20 OR id_subcat = 24  OR id_subcat = 25 OR id_subcat = 27 OR id_subcat = 28 ORDER BY RANDOM() LIMIT 20';
my $raf_mech = 'SELECT id_quest, quest_text, ans_a, ans_b, ans_c, ans_d, right_ans, img FROM questions where id_subcat = 13 OR id_subcat = 14  OR id_subcat = 15 OR id_subcat = 16 OR id_subcat = 17 OR id_subcat = 18 OR id_subcat = 19 ORDER BY RANDOM() LIMIT 20';

my $nonverb;
my $verb;
my $mech;
my $num;
my $result;

sub generate {
    
    my $service = $_[1];
    debug "SERVICE =====> " . $service;

    if ($service eq 'army'){
        $nonverb = get_questions($army_nonverb);
        $verb = get_questions($army_verb);
        $num = get_questions($army_num);
    } 
    elsif ($service eq 'navy'){
        $nonverb = get_questions($navy_nonverb);
        $verb = get_questions($navy_verb);
        $num = get_questions($navy_num);
        $mech = get_questions($navy_mech);
    }
    else {
        $nonverb = get_questions($raf_nonverb);
        $verb = get_questions($raf_verb);
        $num = get_questions($raf_num);
        $mech = get_questions($raf_mech);
    }
    debug "Mech =====" . $mech;
    return ($nonverb, $verb, $num, $mech);  
    
}
sub check_answers {
    $result = 0;
    my %hash;
    my @right_answers;
    my $given_answers;
    my @ids = params->{id_quest};
    %hash = (params->{id_quest}, params->{right_ans});
    
    #print Dumper (@ids);
    #print Dumper (@right_answers);
    print Dumper (%hash);

}
sub get_questions {
    $sql = shift;
    debug "SQL ===> " . $sql;
    $sth = $db->prepare($sql) or die $db->errstr;
    $sth->execute() or die $sth->errstr;
    my $questions = $sth->fetchall_arrayref( {} );
    debug "QUESTIONS =======> " . $questions;
    return $questions;
}

true;



