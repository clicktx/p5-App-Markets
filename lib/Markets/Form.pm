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
    $app->helper( form_error  => sub { _form_render( 'render_error', @_ ) } );
    $app->helper( form_help   => sub { _form_render( 'render_help',  @_ ) } );
    $app->helper( form_label  => sub { _form_render( 'render_label', @_ ) } );
    $app->helper( form_set    => sub { _form_set(@_) } );
    $app->helper( form_widget => sub { _form_render( 'render',       @_ ) } );
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
    my $method = shift;
    my $self   = shift;
    my ( $form, $field_key ) = shift =~ /(.+?)\.(.+)/;

    return _form_set( $self, $form )->$method($field_key, @_);
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
