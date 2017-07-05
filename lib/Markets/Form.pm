package Markets::Form;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app ) = @_;

    # Load filters and validators
    $app->plugin($_) for qw(Markets::Form::CustomFilter Markets::Form::CustomValidator);

    # Helpers
    $app->helper( form_error_message => sub { _form_error_message(@_) } );
}

# messages from [jQuery Validation Plugin](https://github.com/jquery-validation/jquery-validation/blob/master/src/core.js#L344)
# messages: {
#     required: "This field is required.",
#     remote: "Please fix this field.",
#     email: "Please enter a valid email address.",
#     url: "Please enter a valid URL.",
#     date: "Please enter a valid date.",
#     dateISO: "Please enter a valid date (ISO).",
#     number: "Please enter a valid number.",
#     digits: "Please enter only digits.",
#     equalTo: "Please enter the same value again.",
#     maxlength: $.validator.format( "Please enter no more than {0} characters." ),
#     minlength: $.validator.format( "Please enter at least {0} characters." ),
#     rangelength: $.validator.format( "Please enter a value between {0} and {1} characters long." ),
#     range: $.validator.format( "Please enter a value between {0} and {1}." ),
#     max: $.validator.format( "Please enter a value less than or equal to {0}." ),
#     min: $.validator.format( "Please enter a value greater than or equal to {0}." ),
#     step: $.validator.format( "Please enter a multiple of {0}." )
# },

# Message for Mojolicious::Validator default validators
my $messages = {
    required => 'This field is required.',
    equal_to => 'Please enter the same value again.',
    in       => 'Vaule is not a choice.',
    like     => 'This field is invelid.',
    size     => 'Please enter a value between {0} and {1} characters long.',
    upload   => 'This field is invelid.',
};

sub _form_error_message {
    my ( $c, $check ) = @_;
    return $messages->{$check};
}

1;
__END__
=encoding utf8

=head1 NAME

Markets::Form - Form for Markets

=head1 DESCRIPTION

=head1 SEE ALSO

L<Mojolicious::Plugin>

=cut
