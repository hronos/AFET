package AFET::Admin;

use Dancer ':syntax';
use strict;
use warnings;
use Dancer::Plugin::Database;
use Dancer::Plugin::SimpleCRUD;
use Dancer::Config;
use AFET;

get '/admin' => sub {
    template 'admin',;
};

# Questions section

get '/admin/questions' => sub {
    my $db = AFET::connect_db();
    my $sql =
'SELECT id_quest, quest_text, ans_a, ans_b, ans_c, ans_d, right_ans, id_categories, id_subcat FROM questions';
    my $sth = $db->prepare($sql) or die $db->errstr;
    $sth->execute() or die $sth->errstr;
    template 'admin_questions',
      { 'questions' => $sth->fetchall_arrayref( {} ) };
};
post '/admin/questions/add' => sub {
    my $quest_text = params->{quest_text} or die "missing question parameter";
    my $ans_a      = params->{ans_a}      or die "missing parameter";
    my $ans_b      = params->{ans_b}      or die "missing parameter";
    my $ans_c      = params->{ans_c}      or die "missing parameter";
    my $ans_d      = params->{ans_d}      or die "missing parameter";
    my $right_ans  = params->{right_ans}  or die "missing parameter";
    my $id_cat    = params->{id_categories} or die "missing parameter";
    my $id_subcat = params->{id_subcat}     or die "missing parameter";

    database->quick_insert(
        'questions',
        {
            quest_text    => $quest_text,
            ans_a         => $ans_a,
            ans_b         => $ans_b,
            ans_c         => $ans_c,
            ans_d         => $ans_d,
            right_ans     => $right_ans,
            id_categories => $id_cat,
            id_subcat     => $id_subcat,

        }
    );

    ## The question was added to the DB, send user back to the previous page.
    redirect '/admin/questions';
};

# Categories section

get '/admin/categories' => sub {
    my $db  = AFET::connect_db();
    my $sql = 'SELECT id_categories, cat_text  FROM categories';
    my $sth = $db->prepare($sql) or die $db->errstr;
    $sth->execute() or die $sth->errstr;
    template 'admin_categories',
      { 'categories' => $sth->fetchall_arrayref( {} ) };
};
post '/admin/categories/add' => sub {
    my $cat_text = params->{cat_text} or die "missing parameter";

    database->quick_insert( 'categories', { cat_text => $cat_text, } );

    ## The category was added to the DB, send user back to the previous page.
    redirect '/admin/categories';
};

# Subcat section

get '/admin/subcat' => sub {
    my $db  = AFET::connect_db();
    my $sql = 'SELECT id_subcat, subcat_name, id_categories  FROM subcat';
    my $sth = $db->prepare($sql) or die $db->errstr;
    $sth->execute() or die $sth->errstr;
    template 'admin_subcat', { 'subcat' => $sth->fetchall_arrayref( {} ) };
};
post '/admin/subcat/add' => sub {
    my $id_categories = params->{id_categories} or die "missing parameter";
    my $subcat_name   = params->{subcat_name}   or die "missing parameter";

    database->quick_insert(
        'subcat',
        {
            id_categories => $id_categories,
            subcat_name   => $subcat_name,
        }
    );

    ## The subcategory was added to the DB, send user back to the previous page.
    redirect '/admin/subcat';
};

# Users

get '/admin/users' => sub {
    my $db  = AFET::connect_db();
    my $sql = 'SELECT id_user, username, pass, email, id_roles FROM users';
    my $sth = $db->prepare($sql) or die $db->errstr;
    $sth->execute() or die $sth->errstr;
    template 'admin_users', { 'users' => $sth->fetchall_arrayref( {} ) };
};
post '/admin/users/add' => sub {
    my $username = params->{username} or die "missing parameter";
    my $pass     = params->{pass}     or die "missing parameter";
    my $email    = params->{email}    or die "missing parameter";
    my $id_roles = params->{id_roles} or die "missing parameter";

    database->quick_insert(
        'users',
        {
            username => $username,
            pass     => $pass,
            email    => $email,
            id_roles => $id_roles,
        }
    );

    ## The user was added to the DB, send user back to the previous page.
    redirect '/admin/users';
};

simple_crud(
    record_title => 'Users',
    prefix       => '/admin/db/users',
    db_table     => 'users',
    editable     => 1,
    deletable    => 1,
    sortable     => 1,
    key_column  => 'id_user',
);

true;
