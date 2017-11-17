package Yetie::Form;
use Mojo::Base 'Mojolicious::Plugin';
use Scalar::Util qw(weaken);
use Yetie::Util qw(load_class);
use Yetie::Form::Base;

my $NAME_SPACE = 'Yetie::Form::FieldSet';
my $STASH_KEY  = 'yetie.form';

sub register {
    my ( $self, $app ) = @_;

    # Load filters and validators
    $app->plugin($_) for qw(Yetie::Form::Filter Yetie::Form::Validator);

    $app->plugin( 'Yetie::Form::TagHelpers' => { stash_key => $STASH_KEY } );

    # Helpers
    $app->helper( form       => sub { _form(@_) } );
    $app->helper( form_field => sub { _form_field(@_) } );
    $app->helper( form_set   => sub { _form_set(@_) } );

    # Tag Helpers
    $app->helper( form_error => sub { _form_render( 'render_error', @_ ) } );
    $app->helper( form_help  => sub { _form_render( 'render_help',  @_ ) } );
    $app->helper( form_label => sub { _form_render( 'render_label', @_ ) } );

    # $app->helper( form_widget => sub { _form_render( 'render',       @_ ) } );
}

sub _form {
    my ( $c, $name ) = @_;
    die 'Arguments empty.' unless $name;

    # my $name = shift || $c->stash('controller') . '-' . $c->stash('action');
    # $name = camelize($name) if $name =~ /^[a-z]/;

    $c->stash( $STASH_KEY . '.topic' => $name );

    $c->stash( $STASH_KEY => {} ) unless ref $c->stash($STASH_KEY) eq 'HASH';
    my $form = $c->stash($STASH_KEY)->{$name};
    if ( !$form ) {
        $form = Yetie::Form::Base->new( $name, controller => $c );
        weaken $form->{controller};

        # Add trigger
        # $c->app->plugins->emit_hook( after_build_form => $c, $form, $name );

        $c->stash($STASH_KEY)->{$name} = $form;
    }
    return $form;
}

sub _form_field {
    my ( $c, $topic ) = @_;
    die 'Arguments empty.' unless $topic;

    $c->stash( $STASH_KEY . '.topic_field' => $topic );
    return;
}

sub _form_set {
    my $c = shift;

    my $ns = shift || $c->stash('controller') . '-' . $c->stash('action');
    $ns = Mojo::Util::camelize($ns) if $ns =~ /^[a-z]/;

    $c->stash( $STASH_KEY => {} ) unless $c->stash($STASH_KEY);
    my $formset = $c->stash($STASH_KEY)->{$ns};
    return $formset if $formset;

    my $class = $NAME_SPACE . "::" . $ns;
    load_class($class);

    $formset = $class->new( controller => $c );
    $c->stash($STASH_KEY)->{$ns} = $formset;
    return $formset;
}

sub _form_render {
    my ( $method, $c, $topic_field ) = ( shift, shift, shift );

    $topic_field = $c->stash( $STASH_KEY . '.topic_field' ) unless $topic_field;
    my ( $fieldset, $field_key ) = $topic_field =~ /(.*)#(.+)/;

    return _form( $c, $fieldset )->$method( $field_key, @_ );
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Form - Form for Yetie

=head1 SYNOPSIS

    # Mojolicious
    $app->plugin('Yetie::Form');

    # Mojolicious::Lite
    plugin 'Yetie::Form';

=head2 Custom Error Messages

    package Yetie::Form::FieldSet::Category;
    use Mojo::Base -strict;
    use Yetie::Form::FieldSet;

    has_field 'title' => (
        type        => 'text',
        ...
        error_messages => {
            custom_error => 'foo {0}',
            custom_error2 => 'bar {0} {1}',
            custom_error3 => sub {
                return @_ > 1
                  ? 'Please enter a value between {0} and {1} characters long.'
                  : 'Please enter a value {0} characters long.';
            },
            ...
        },
    );
    ...

error_message attribute.

    # In controller
    my $form = $controller->form_set('category');
    return $controller->render() unless $form->validate;

    # Add or rewrite error message
    $form->field('title')->error_message( custom_error => 'foo bar {0}' );

    my $bool = $model->is_error( $form->param('title') );
    if ($bool) {
        # Error message is "foo bar buz"
        $form->validation->error( title => [ 'custom_error', 1, ('buz') ] );
        return $controller->render();
    }

Handle custom error messages in the controller.

=head1 DESCRIPTION

=head1 HELPERS

L<Yetie::Form> implements the following helpers.

=head2 C<form_field>

    # In templates
    <%= form_field 'foo-bar#field1' %>
    <%= form_label %>
    <%= form_widget %>
    <%= form_error %>

Set the current topic.

Return none.
Cache the currently used form-field in "$c->stash".

=head2 C<form_set>

    # Yetie::Form::FieldSet::Example
    my $form_set = $c->form_set('example');

    # Yetie::Form::FieldSet::Admin::Example
    my $form_set = $c->form_set('admin-example');

    # Controller is "Hoge" and Action is "index"
    # require class is Yetie::Form::FieldSet::Hoge::Index
    my $form_set = $c->form_set();

Return L<Yetie::Form::FieldSet> object.

Namespace C<Yetie::Form::FieldSet::*>

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
    %= form_label('example#email', class => 'hoge')

    # Longer Version
    %= form_set('example')->render_label('email')

Rendering tag from Yetie::Form::Type::xxx.
L<Mojolicious::Plugin::TagHelpers> wrapper method.

Only "class" attribute can be added.

=head2 C<form_widget>

    # In template
    %= form_widget('example#email')

    # Longer Version
    %= form_set('example')->render_widget('email')

    # With attributes
    %= form_widget('example#email', value => 'name@domain.com')

Rendering tag from Yetie::Form::Type::xxx.
L<Mojolicious::Plugin::TagHelpers> wrapper method.

=head1 METHODS

L<Yetie::Form> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register helpers in L<Mojolicious> application.

=head1 SEE ALSO

L<Yetie::Form::Base>, L<Yetie::Form::FieldSet>, L<Yetie::Form::Field>, L<Mojolicious::Plugin>

=cut
