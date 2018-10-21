package Yetie::App::Core::Form;
use Mojo::Base 'Mojolicious::Plugin';
use Scalar::Util qw(weaken);
use Yetie::Form::Base;

my $STASH_KEY = 'yetie.form';

sub register {
    my ( $self, $app, $conf ) = @_;
    my $stash_key = $conf->{stash_key} || $STASH_KEY;

    # Load filters and validators
    $app->plugin($_) for qw(Yetie::App::Core::Validator::Filters Yetie::App::Core::Validator);

    # Helpers
    $app->helper( form => sub { _form( $stash_key, @_ ) } );
    $app->helper( form_field => sub { _form_field( $stash_key, @_ ) } );

    # Tag Helpers
    $app->helper( form_error => sub { _form_error( $stash_key, @_ ) } );
    $app->helper( form_help => sub { _form_help( $stash_key, @_ ) } );
    $app->helper( form_label => sub { _form_label( $stash_key, @_ ) } );
    $app->helper( form_widget => sub { _form_widget( $stash_key, @_ ) } );
}

sub _form {
    my ( $stash_key, $c, $name ) = @_;
    die 'Arguments empty.' unless $name;

    $c->stash( $stash_key . '.topic' => $name );
    $c->stash( $stash_key => {} ) unless ref $c->stash($stash_key) eq 'HASH';
    my $form = $c->stash($stash_key)->{$name};
    if ( !$form ) {
        $form = Yetie::Form::Base->new( $name, controller => $c );
        weaken $form->{controller};

        # Add trigger
        # $c->app->plugins->emit_hook( after_build_form => $c, $form, $name );

        $c->stash($stash_key)->{$name} = $form;
    }
    return $form;
}

sub _form_field {
    my ( $stash_key, $c, $topic ) = @_;
    die 'Arguments empty.' unless $topic;

    my ( $form, $field ) = $topic =~ /#/ ? $topic =~ /(.*)#(.+)/ : ( undef, $topic );
    $c->form($form) if $form;
    $c->stash( $stash_key . '.topic_field' => $field );
    return;
}

sub _form_error {
    my ( $form, $topic_field ) = _topic(@_);
    $form->render_error($topic_field);
}

sub _form_help {
    my ( $form, $topic_field ) = _topic(@_);
    $form->render_help($topic_field);
}

sub _form_label {
    my ( $form, $topic_field, %attrs ) = _topic(@_);
    $form->render_label( $topic_field, %attrs );
}

sub _form_widget {
    my ( $form, $topic_field, %attrs ) = _topic(@_);
    $form->render( $topic_field, %attrs );
}

sub _topic {
    my ( $stash_key, $c ) = ( shift, shift );

    my $topic =
      ( @_ ? @_ % 2 ? shift : $c->stash( $stash_key . '.topic_field' ) : $c->stash( $stash_key . '.topic_field' ) )
      || '';
    my ( $topic_form, $topic_field ) = $topic =~ /#/ ? $topic =~ /(.*)#(.+)/ : ( undef, $topic );
    die 'Unable to set field name' unless $topic_field;

    $topic_form = $c->stash( $stash_key . '.topic' ) unless $topic_form;
    die 'Unable to set form' unless $topic_form;

    my $form = $c->form($topic_form);
    return ( $form, $topic_field, @_ );
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::App::Core::Form - Form for Yetie

=head1 SYNOPSIS

    # Mojolicious
    $app->plugin('Yetie::App::Core::Form');

    # Mojolicious::Lite
    plugin 'Yetie::App::Core::Form';

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

Customize the error messages in the controller.
Use C<error_message> method.

    # In controller
    my $form = $controller->form('category');
    return $controller->render() unless $form->do_validate;

    # Add or rewrite error message
    $form->field('title')->error_message( custom_error => 'foo bar {0}' );

    my $bool = $model->is_error( $form->param('title') );
    if ($bool) {
        # Error message is "foo bar buz"
        $form->validation->error( title => [ 'custom_error', 1, ('buz') ] );
        return $controller->render();
    }

=head1 DESCRIPTION

=head1 HELPERS

L<Yetie::App::Core::Form> implements the following helpers.

=head2 C<form>

    # Yetie::Form::FieldSet::Example
    my $form = $c->form('example');

    # Yetie::Form::FieldSet::Admin::Example
    my $form = $c->form('admin-example');

    # Controller is "Foo" and Action is "index"
    # require class is Yetie::Form::FieldSet::Foo::Index
    my $form = $c->form();

Return L<Yetie::Form::FieldSet> object.
And Set it to the current topic form.

=head2 C<form_field>

    # In templates
    %= form_field 'foo-bar#field'
    %= form_label
    %= form_widget
    %= form_error

Return none.
Set it to the current topic form-field.

Cache the currently used form-field in "$c->stash".

=head1 TAG HELPERS

All helpers are L<Mojolicious::Plugin::TagHelpers> wrapper.

=head2 C<form_error>

    # In template
    %= form_error('example#email')

Rendering error message.

The default class for this block is "form-error-block".

=head2 C<form_help>

    # In template
    %= form_help('example#email')

The default class for this block is "form-help-block".

=head2 C<form_label>

    # In template
    %= form_label('example#email')
    %= form_label('example#email', class => 'foo')

Rendering C<E<lt>labelE<gt>> tag.

Only "class" attribute can be added.

=head2 C<form_widget>

    # In template
    %= form_widget('example#email')
    %= form_widget('example#email', value => 'name@domain.com')
    %= form_widget('example#email', %attrs)

    # Change type
    %= form_widget('example#email', type => 'text')

Rendering C<E<lt>inputE<gt>>, C<E<lt>textareaE<gt>>, C<E<lt>selectE<gt>>, C<E<lt>radioE<gt>>, C<E<lt>checkboxE<gt>>, C<E<lt>hiddenE<gt>> tag.

Can add arbitrary attributes.

=head1 METHODS

L<Yetie::App::Core::Form> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register helpers in L<Mojolicious> application.

=head1 SEE ALSO

L<Yetie::Form::Base>, L<Yetie::Form::FieldSet>, L<Yetie::Form::Field>, L<Yetie::App::Core::Form::TagHelpers>,
L<Mojolicious::Plugin>

=cut
