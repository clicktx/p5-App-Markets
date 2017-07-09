package Markets::Form;
use Mojo::Base 'Mojolicious::Plugin';
use Markets::Util qw(load_class);

my $FORM_CLASS = 'Markets::Form::FieldSet';
my $FORM_STASH = 'markets.form';

sub register {
    my ( $self, $app ) = @_;

    # Load filters and validators
    $app->plugin($_) for qw(Markets::Form::Filter Markets::Form::Validator);

    # Helpers
    $app->helper( form_error => sub { _form_render( @_, 'render_error' ) } );
    $app->helper( form_error_message => sub { _form_error_message(@_) } );
    $app->helper( form_help          => sub { _form_render( @_, 'render_help' ) } );
    $app->helper( form_label         => sub { _form_render( @_, 'render_label' ) } );
    $app->helper( form_set           => sub { _form_set(@_) } );
    $app->helper( form_widget        => sub { _form_render( @_, 'render' ) } );
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
    length   => sub {
        return @_ > 1
          ? 'Please enter a value between {0} and {1} characters long.'
          : 'Please enter a value {0} characters long.';
    },
};

sub _form_error_message {
    my ( $c, $check, @args ) = @_;
    return ref $messages->{$check} eq 'CODE' ? $messages->{$check}->(@args) : $messages->{$check};
}

sub _form_set {
    my ( $self, $ns ) = @_;
    $ns = Mojo::Util::camelize($ns) if $ns =~ /^[a-z]/;
    Carp::croak 'Arguments empty' unless $ns;

    $self->stash( $FORM_STASH => {} ) unless $self->stash($FORM_STASH);
    my $formset = $self->stash($FORM_STASH)->{$ns};
    return $formset if $formset;

    my $class = $FORM_CLASS . "::" . $ns;
    load_class($class);

    $formset = $class->new( controller => $self );
    $self->stash($FORM_STASH)->{$ns} = $formset;
    return $formset;
}

sub _form_render {
    my $self = shift;
    my ( $form, $field_key ) = shift =~ /(.+?)\.(.+)/;
    my $method = shift;
    return _form_set( $self, $form )->$method($field_key);
}

1;
__END__
=encoding utf8

=head1 NAME

Markets::Form - Form for Markets

=head1 SYNOPSIS

    # Mojolicious
    $app->plugin('Markets::Form');

    # Mojolicious::Lite
    plugin 'Markets::Form';

=head1 DESCRIPTION

=head1 HELPERS

L<Markets::Form> implements the following helpers.

=head2 C<form_error_message>

    my ($check, $result, @args) = @{$c->validation->error('field_name')};
    $c->form_error_message($check);

=head2 C<form_set>

    my $form_set = $c->form_set('example');

=head1 TAG HELPERS

All helpers are L<Mojolicious::Plugin::TagHelpers> wrapper.

=head2 C<form_error>

    # In template
    %= form_error('example.email')

    # Longer Version
    %= form_set('example')->render_error('email')

=head2 C<form_help>

    # In template
    %= form_help('example.email')

    # Longer Version
    %= form_set('example')->render_help('email')

=head2 C<form_label>

    # In template
    %= form_label('example.email')

    # Longer Version
    %= form_set('example')->render_label('email')

Rendering tag from Markets::Form::Type::xxx.
L<Mojolicious::Plugin::TagHelpers> wrapper method.

=head2 C<form_widget>

    # In template
    %= form_widget('example.email')

    # Longer Version
    %= form_set('example')->render_widget('email')

Rendering tag from Markets::Form::Type::xxx.
L<Mojolicious::Plugin::TagHelpers> wrapper method.

=head1 METHODS

L<Markets::Form> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register helpers in L<Mojolicious> application.

=head1 SEE ALSO

L<Mojolicious::Plugin>

=cut
