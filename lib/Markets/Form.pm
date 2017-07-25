package Markets::Form;
use Mojo::Base 'Mojolicious::Plugin';
use Markets::Util qw(load_class);

my $NAME_SPACE = 'Markets::Form::FieldSet';
my $STASH_NAME = 'markets.form';

sub register {
    my ( $self, $app ) = @_;

    # Load filters and validators
    $app->plugin($_) for qw(Markets::Form::Filter Markets::Form::Validator);

    # Helpers
    $app->helper( form_error  => sub { _form_render( 'render_error', @_ ) } );
    $app->helper( form_field  => sub { _form_field(@_) } );
    $app->helper( form_help   => sub { _form_render( 'render_help',  @_ ) } );
    $app->helper( form_label  => sub { _form_render( 'render_label', @_ ) } );
    $app->helper( form_set    => sub { _form_set(@_) } );
    $app->helper( form_widget => sub { _form_render( 'render',       @_ ) } );
}

sub _form_field {
    my ( $c, $topic ) = @_;
    die 'Arguments empty.' unless $topic;

    $c->stash( $STASH_NAME . '.topic_field' => $topic );
    return;
}

sub _form_set {
    my $c = shift;

    my $ns = shift || $c->stash('controller') . '-' . $c->stash('action');
    $ns = Mojo::Util::camelize($ns) if $ns =~ /^[a-z]/;

    $c->stash( $STASH_NAME => {} ) unless $c->stash($STASH_NAME);
    my $formset = $c->stash($STASH_NAME)->{$ns};
    return $formset if $formset;

    my $class = $NAME_SPACE . "::" . $ns;
    load_class($class);

    $formset = $class->new( controller => $c );
    $c->stash($STASH_NAME)->{$ns} = $formset;
    return $formset;
}

sub _form_render {
    my ( $method, $c, $topic_field ) = ( shift, shift, shift );

    $topic_field = $c->stash( $STASH_NAME . '.topic_field' ) unless $topic_field;
    my ( $fieldset, $field_key ) = $topic_field =~ /(.*)#(.+)/;

    return _form_set( $c, $fieldset )->$method( $field_key, @_ );
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

=head2 C<form_field>

    # In templates
    <%= form_field 'foo-bar#field1' %>
    <%= form_label %>
    <%= form_widget %>
    <%= form_error %>

Return none.
Cache the currently used form-field in "$c->stash".

=head2 C<form_set>

    # Markets::Form::FieldSet::Example
    my $form_set = $c->form_set('example');

    # Markets::Form::FieldSet::Admin::Example
    my $form_set = $c->form_set('admin-example');

    # Controller is "Hoge" and Action is "index"
    # require class is Markets::Form::FieldSet::Hoge::Index
    my $form_set = $c->form_set();

Return L<Markets::Form::FieldSet> object.

Namespace C<Markets::Form::FieldSet::*>

=head1 TAG HELPERS

All helpers are L<Mojolicious::Plugin::TagHelpers> wrapper.

=head2 C<form_error>

    # In template
    %= form_error('example#email')

    # Longer Version
    %= form_set('example')->render_error('email')

=head2 C<form_help>

    # In template
    %= form_help('example#email')

    # Longer Version
    %= form_set('example')->render_help('email')

=head2 C<form_label>

    # In template
    %= form_label('example#email')

    # Longer Version
    %= form_set('example')->render_label('email')

Rendering tag from Markets::Form::Type::xxx.
L<Mojolicious::Plugin::TagHelpers> wrapper method.

=head2 C<form_widget>

    # In template
    %= form_widget('example#email')

    # Longer Version
    %= form_set('example')->render_widget('email')

    # With attributes
    %= form_widget('example#email', value => 'name@domain.com')

Rendering tag from Markets::Form::Type::xxx.
L<Mojolicious::Plugin::TagHelpers> wrapper method.

=head1 METHODS

L<Markets::Form> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register helpers in L<Mojolicious> application.

=head1 SEE ALSO

L<Markets::Form::FieldSet>, L<Markets::Form::Field>, L<Mojolicious::Plugin>

=cut
