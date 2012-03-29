package AFET::Contact;
# package to deal with custom tests

use Dancer ':syntax';
use strict;
use warnings;
use Dancer::Plugin::Database;
use Dancer::Config;
use Data::Dumper;
use Dancer::Plugin::Email;

post '/contact/send' => sub { # Method to send email
    my $params = params;
    my $name = params->{'name'};
    my $message = params->{'msg'};
    my $email = params->{'email'};
   # Function to send email
    email{
    type       => 'text',
    to         => 'lennartta@gmail.com',
    subject    => "Contact from $name via website",
    msg        => "$message from $email",
    };
    redirect '/contact/sent'; # Redirect to sent page
};

true;
