package Markets::DefaultHelpers;
use Mojo::Base 'Mojolicious::Plugin';

use Carp         ();
use Scalar::Util ();
use Mojo::Util   ();
use Markets::Util qw(load_class);
use Markets::Domain::Factory;

my $FORM_CLASS = 'Markets::Form::FieldSet';
my $FORM_STASH = 'markets.form';

sub register {
    my ( $self, $app ) = @_;

    # $app->helper( schema         => sub { shift->app->schema } ); # controllerから呼ばない
    $app->helper( addons         => sub { shift->app->addons(@_) } );
    $app->helper( cookie_session => sub { shift->session(@_) } );
    $app->helper( cart           => sub { _cart(@_) } );
    $app->helper( factory        => sub { _factory(@_) } );
    $app->helper( form_set       => sub { _form_set(@_) } );
    $app->helper( form_label     => sub { _form_render( @_, 'render_label' ) } );
    $app->helper( form_widget    => sub { _form_render( @_, 'render' ) } );
    $app->helper( pref           => sub { _pref(@_) } );
    $app->helper( service        => sub { _service(@_) } );
    $app->helper( template       => sub { shift->stash( template => shift ) } );
}

sub _cart { @_ > 1 ? $_[0]->stash( 'markets.entity.cart' => $_[1] ) : $_[0]->stash('markets.entity.cart') }

sub _factory { shift; Markets::Domain::Factory->new->factory(@_) }

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

sub _pref {
    my $self = shift;
    my $pref = $self->stash('markets.entity.preference');
    return @_ ? $pref->value(@_) : $pref;
}

sub _service {
    my ( $self, $ns ) = @_;
    $ns = Mojo::Util::camelize($ns) if $ns =~ /^[a-z]/;
    Carp::croak 'Service name is empty.' unless $ns;

    my $service = $self->app->{services}{$ns};
    if ( Scalar::Util::blessed $service ) {
        $service->controller($self);
        Scalar::Util::weaken $service->{controller};
    }
    else {
        my $class = "Markets::Service::" . $ns;
        load_class($class);
        $service = $class->new($self);
        $self->app->{services}{$ns} = $service;
    }
    return $service;
}

1;
__END__

=head1 NAME

Markets::DefaultHelpers - Default helpers plugin for Markets

=head1 DESCRIPTION

=head1 HELPERS

=head2 C<addons>

    my $addons = $c->addons;

Alias for $app->addons;

=head2 C<cookie_session>

    $c->cookie_session( key => 'value' );
    my $value = $c->cookie_session('key');

Alias for $c->session;

=head2 C<cart>

    my $cart = $c->cart;
    $c->cart($cart);

=head2 C<factory>

    my $factory = $c->factory('entity-something');

Return L<Markets::Domain::Factory> Object.

=head2 C<form_set>

    my $form_set = $c->form_set('example');

=head2 C<form_label>

    # In template
    %= form_label('example.address')

    # Longer Version
    %= form_set('example')->render_label('email')->(app)

Rendering tag from Markets::Form::Type::xxx.
L<Mojolicious::Plugin::TagHelpers> wrapper method.

=head2 C<form_widget>

    # In template
    %= form_widget('example.address')

    # Longer Version
    %= form_set('example')->render_widget('email')->(app)

Rendering tag from Markets::Form::Type::xxx.
L<Mojolicious::Plugin::TagHelpers> wrapper method.

=head2 C<pref>

    # Get preference entity
    my $entity_preference = $c->pref;

    # Getter
    my $hoge = $c->pref('hoge');

    # Setter
    $c->pref( hoge => 'fizz', fuga => 'bazz' );

Get/Set preference.

=head2 C<service>

    # Your service
    package Markets::Service::Cart;

    sub calculate {
        my $self = shift;
        my $c = $self->controller;
        ...
    }

    # Your controller
    $c->service('cart')->calculate(...);
    $c->helpers->service('cart')->calculate(...);


Service Layer accessor.

=head2 C<template>

    $c->template('hoge/index');

Alias for $c->stash(template => 'hoge/index');

=head1 AUTHOR

Markets authors.
