# Class for everything to do with tests
package AFET::Test;


use Dancer ':syntax';
use strict;
use warnings;
use Dancer::Config;
use Dancer::Plugin::Database;
use Data::Dumper;

my $db = AFET->connect_db(); # Call our main class AFET, method connect_db
my $sql;
my $sth;

####  Define SQL for different categories/service ####
my $army_nonverb =
'SELECT id_quest, quest_text, ans_a, ans_b, ans_c, ans_d, right_ans, img, id_subcat FROM questions where id_subcat = 1 OR id_subcat = 2 ORDER BY RANDOM() LIMIT 10';
my $army_verb =
'SELECT id_quest, quest_text, ans_a, ans_b, ans_c, ans_d, right_ans, img, id_subcat FROM questions where id_subcat = 5 OR id_subcat = 6 OR id_subcat = 8 ORDER BY RANDOM() LIMIT 10';
my $army_num =
'SELECT id_quest, quest_text, ans_a, ans_b, ans_c, ans_d, right_ans, img, id_subcat FROM questions where id_subcat = 29 OR id_subcat = 20  OR id_subcat = 24 OR id_subcat = 25 ORDER BY RANDOM() LIMIT 10';

my $navy_nonverb =
'SELECT id_quest, quest_text, ans_a, ans_b, ans_c, ans_d, right_ans, img, id_subcat FROM questions where id_subcat = 2 OR id_subcat = 4 ORDER BY RANDOM() LIMIT 10';
my $navy_verb =
'SELECT id_quest, quest_text, ans_a, ans_b, ans_c, ans_d, right_ans, img, id_subcat FROM questions where id_subcat = 5 OR id_subcat = 8 OR id_subcat = 9 OR id_subcat = 10 OR id_subcat = 11 OR id_subcat = 12 ORDER BY RANDOM() LIMIT 10';
my $navy_num =
'SELECT id_quest, quest_text, ans_a, ans_b, ans_c, ans_d, right_ans, img, id_subcat FROM questions where id_subcat = 20 OR id_subcat = 22  OR id_subcat = 23 OR id_subcat = 24 OR id_subcat = 25 OR id_subcat = 26 OR id_subcat = 27 ORDER BY RANDOM() LIMIT 10';
my $navy_mech =
'SELECT id_quest, quest_text, ans_a, ans_b, ans_c, ans_d, right_ans, img, id_subcat FROM questions where id_subcat = 13 OR id_subcat = 14  OR id_subcat = 15 OR id_subcat = 16 OR id_subcat = 17 OR id_subcat = 18 ORDER BY RANDOM() LIMIT 10';

my $raf_nonverb =
'SELECT id_quest, quest_text, ans_a, ans_b, ans_c, ans_d, right_ans, img, id_subcat FROM questions where id_subcat = 2 OR id_subcat = 3 OR id_subcat = 4 ORDER BY RANDOM() LIMIT 10';
my $raf_verb =
'SELECT id_quest, quest_text, ans_a, ans_b, ans_c, ans_d, right_ans, img, id_subcat FROM questions where id_subcat = 8 OR id_subcat = 11 OR id_subcat = 4 ORDER BY RANDOM() LIMIT 10';
my $raf_num =
'SELECT id_quest, quest_text, ans_a, ans_b, ans_c, ans_d, right_ans, img, id_subcat FROM questions where id_subcat = 20 OR id_subcat = 24  OR id_subcat = 25 OR id_subcat = 27 OR id_subcat = 28 ORDER BY RANDOM() LIMIT 10';
my $raf_mech =
'SELECT id_quest, quest_text, ans_a, ans_b, ans_c, ans_d, right_ans, img, id_subcat FROM questions where id_subcat = 13 OR id_subcat = 14  OR id_subcat = 15 OR id_subcat = 16 OR id_subcat = 17 OR id_subcat = 18 OR id_subcat = 19 ORDER BY RANDOM() LIMIT 10';
### END SQL ####

### Global class variables ###
my $nonverb;
my $verb;
my $mech;
my $num;
my $result;
### End variables ###

# Generate questions method
sub generate {

    my $service = $_[1]; # Service gets passed to class as 2nd member of array. First member will always be class name - AFET::Test

    if ( $service eq 'army' ) {                     # Army test
        $nonverb = get_questions($army_nonverb);
        $verb    = get_questions($army_verb);
        $num     = get_questions($army_num);
        $mech    = '';                              # there is no mechanical comprehension
    }
    elsif ( $service eq 'navy' ) {                  # Navy test
        $nonverb = get_questions($navy_nonverb);
        $verb    = get_questions($navy_verb);
        $num     = get_questions($navy_num);
        $mech    = get_questions($navy_mech);
    }
    else {
        $nonverb = get_questions($raf_nonverb);     # Raf test
        $verb    = get_questions($raf_verb);
        $num     = get_questions($raf_num);
        $mech    = get_questions($raf_mech);
    }
    return ( $nonverb, $verb, $num, $mech );

}

# Check answers method
sub check_answers {
    $result = 0;                                                        # Initial result is 0
    my $right_answer;
    my $given_answer;
    my @wrong_subcats;                                                  # We want to know subcategories in which user made mistakes.
    my $ids_ref = params->{'id_quest'};                                 # Get question ids from form
    foreach my $id ( ref($ids_ref) ? @$ids_ref : $ids_ref ) {           # Dereference id array and split into individual ids.
        $right_answer = params->{"right_ans_$id"};                      # Get right answer for this question
        $given_answer = params->{"answer_$id"};                         # Get whatever user entered
        if ( defined $given_answer && $given_answer eq $right_answer ) {# RIGHT answer
            $result++;
        }
        else {
            my $wrong_subcat = params->{"subcat_$id"};                  # WRONG answer
            if ( $wrong_subcat ) {                                      # Add subcategory to array
                my $subcat = get_subcat_name($wrong_subcat);            # Call get subcat name by id function
                push (@wrong_subcats, $subcat);
                debug "WRONG SUBS" . @wrong_subcats;                    # output to log console for debugging
            }
        }
    }
    ### Making wrong subs array unique - hash keys have to be unique, hence can be done as following: ###
    my %seen;                                                           # Define hash
    @seen{@wrong_subcats} = ();                                         # Map array wrong subs to hash
    my @unique_subs = keys %seen;                                       # assign keys from hash to new unique array
    ### Unique end ###

    my $sub_scal = "@unique_subs"; # Assign array to scalar to return 
    return ( $result, $sub_scal);

}

# Get questions method
sub get_questions {                                                     
    $sql = shift;                                                       # get sql string passed to method
    $sth = $db->prepare($sql) or die $db->errstr;                       # connect to database or die if fails
    $sth->execute() or die $sth->errstr;                                # execute sql or die if fails
    my $questions = $sth->fetchall_arrayref( {} );                      # Get questions array
    return $questions;                      
}

# Method to get subcat name by its id
sub get_subcat_name {
    my $id = shift;                                                         # get id passed to us
    my $subcat_name = database->quick_select('subcat', {id_subcat => $id}); # Do a quick select by id
    $subcat_name = $subcat_name->{subcat_name};                             # Get a name
    return $subcat_name;
}

true;

