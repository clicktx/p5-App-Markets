package Markets::DefaultHelpers;
use Mojo::Base 'Mojolicious::Plugin';

use Carp         ();
use Scalar::Util ();
use Mojo::Util   ();
use Markets::Util qw(load_class);
use Markets::Domain::Factory;

sub register {
    my ( $self, $app ) = @_;

    $app->helper( __x_default_lang => sub { __x_default_lang(@_) } );
    $app->helper( addons           => sub { shift->app->addons(@_) } );
    $app->helper( cookie_session   => sub { shift->session(@_) } );
    $app->helper( cart             => sub { _cart(@_) } );
    $app->helper( factory          => sub { _factory(@_) } );
    $app->helper( pref             => sub { _pref(@_) } );
    $app->helper( schema           => sub { shift->app->schema } );
    $app->helper( service          => sub { _service(@_) } );
    $app->helper( template         => sub { _template(@_) } );
}

sub _cart { @_ > 1 ? $_[0]->stash( 'markets.entity.cart' => $_[1] ) : $_[0]->stash('markets.entity.cart') }

sub __x_default_lang {
    my $c = shift;

    my $language = $c->language;
    $c->language( $c->pref('default_language') );
    my $word = $c->__x(@_);
    $c->language($language);
    return $word;
}

sub _factory { shift; Markets::Domain::Factory->new->factory(@_) }

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

sub _template {
    my $c = shift;
    return @_ ? $c->stash( template => shift ) : $c->stash('template');
}

1;
__END__

=head1 NAME

Markets::DefaultHelpers - Default helpers plugin for Markets

=head1 DESCRIPTION

=head1 HELPERS

L<Markets::DefaultHelpers> implements the following helpers.

=head2 C<__x_default_lang>

    my $translation = $c->__x_default_lang($word);

Word translation using L<Mojolicious::Plugin::LocaleTextDomainOO/__x> in the default language.

The default language uses C<default_language> preference.

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

=head2 C<pref>

    # Get preference entity
    my $entity_preference = $c->pref;

    # Getter
    my $hoge = $c->pref('hoge');

    # Setter
    $c->pref( hoge => 'fizz', fuga => 'bazz' );

Get/Set preference.

=head2 C<schema>

    my $schema = $c->schema;

Return L<Markets::Schema> object.

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

    my $template = $c->template;
    $c->template('hoge/index');

Get/Set template.

Alias for $c->stash(template => 'hoge/index');

=head1 AUTHOR

Markets authors.
