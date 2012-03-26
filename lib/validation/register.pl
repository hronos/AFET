{
        # Fields for validating
        fields => [ qw/usr pwd pwd2 email/ ],
        
        checks => [
            [ qw/usr pwd pwd2 email/ ] => is_required("Field required!"),
            
            usr => is_long_between( 4, 25, 'Your login should have between 4 and 25 characters.' ),
            pwd => is_long_between( 4, 40, 'Your password should have between 4 and 40 characters.' ),
            pwd2 => is_equal("pwd", "Passwords don't match"),
            email => sub { check_email($_[0], "Please enter a valid e-mail address.") },
        ],
}
