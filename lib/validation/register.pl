{
        # Fields for validating
        fields => [ qw/usr pwd pwd2/ ],
        
        checks => [
            [ qw/usr pwd pwd2/ ] => is_required("Field required!"),
            
            usr => is_long_between( 2, 25, 'Your login should have between 2 and 25 characters.' ),
            pwd => is_long_between( 4, 40, 'Your password should have between 4 and 40 characters.' ),
            pwd2 => is_equal("pwd", "Passwords don't match"),
        ],
}
