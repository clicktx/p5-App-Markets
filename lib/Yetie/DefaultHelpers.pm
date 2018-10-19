package Yetie::DefaultHelpers;
use Mojo::Base 'Mojolicious::Plugin';

use Carp                    ();
use Scalar::Util            ();
use Mojo::Util              ();
use Yetie::Util             ();
use Yetie::App::Core::Cache ();
use Yetie::Factory;

sub register {
    my ( $self, $app ) = @_;

    # Add attributes to App
    $app->attr( caches => sub { Yetie::App::Core::Cache->new } );

    # TagHelpers more
    $app->plugin('Yetie::TagHelpers');

    $app->helper( __x_default_lang => sub { __x_default_lang(@_) } );
    $app->helper( addons           => sub { shift->app->addons(@_) } );
    $app->helper( cache            => sub { _cache(@_) } );
    $app->helper( cart             => sub { _cart(@_) } );
    $app->helper( cookie_session   => sub { shift->session(@_) } );
    $app->helper( factory          => sub { _factory(@_) } );
    $app->helper( pref             => sub { _pref(@_) } );
    $app->helper( resultset        => sub { shift->app->schema->resultset(@_) } );
    $app->helper( schema           => sub { shift->app->schema } );
    $app->helper( service          => sub { _service(@_) } );
    $app->helper( template         => sub { _template(@_) } );
}

sub __x_default_lang {
    my $c = shift;

    my $language = $c->language;
    $c->language( $c->pref('default_language') );
    my $word = $c->__x(@_);
    $c->language($language);
    return $word;
}

sub _cache {
    my $self = shift;

    my $caches = $self->app->caches;
    return @_ ? @_ > 1 ? $caches->set( $_[0] => $_[1] ) : $caches->get( $_[0] ) : $caches;
}

sub _cart { @_ > 1 ? $_[0]->stash( 'yetie.cart' => $_[1] ) : $_[0]->stash('yetie.cart') }

sub _factory {
    my $self = shift;

    my $factory = Yetie::Factory->new(@_);
    $factory->app( $self->app );
    return $factory;
}

sub _pref {
    my $self = shift;
    my $pref = $self->cache('preferences');
    return @_ ? $pref->value(@_) : $pref;
}

sub _service {
    my ( $self, $ns ) = ( shift, shift );

    $ns = Mojo::Util::camelize($ns) if $ns =~ /^[a-z]/;
    Carp::croak 'Service name is empty.' unless $ns;

    my $class = "Yetie::Service::" . $ns;
    Yetie::Util::load_class($class);
    return $class->new( $self, @_ );
}

sub _template {
    my $c = shift;
    return @_ ? $c->stash( template => shift ) : $c->stash('template');
}

1;
__END__

=head1 NAME

Yetie::DefaultHelpers - Default helpers plugin for Yetie

=head1 DESCRIPTION

=head1 HELPERS

L<Yetie::DefaultHelpers> implements the following helpers.

=head2 C<__x_default_lang>

    my $translation = $c->__x_default_lang($word);

Word translation using L<Mojolicious::Plugin::LocaleTextDomainOO/__x> in the default language.

The default language uses C<default_language> preference.

=head2 C<addons>

    my $addons = $c->addons;

Alias for $app->addons;

=head2 C<cache>

    my $cache = $c->cache;

Return L<Yetie::App::Core::Cache> object.

    # Get cache
        my $foo = $c->cache('foo');

        # Longer version
        my $foo = $c->cache->get('foo');

    # Set cache
        $c->cache( foo => 'bar' );

        # Longer version
        $c->cache->set( foo => 'bar' );

    # Clear all caches
    $c->cache->clear_all;

SEE L<Yetie::App::Core::Cache>

=head2 C<cart>

    my $cart = $c->cart;
    $c->cart($cart);

=head2 C<cookie_session>

    $c->cookie_session( key => 'value' );
    my $value = $c->cookie_session('key');

Alias for $c->session;

=head2 C<factory>

    my $factory = $c->factory('entity-something');

Return L<Yetie::Factory> Object.

=head2 C<resultset>

    my $resultset = $c->resultset('Foo::Bar');
    my $resultset = $c->resultset('foo-bar');

Return L<Yetie::Schema::ResultSet> object.

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

Return L<Yetie::Schema> object.

=head2 C<service>

    # Your service
    package Yetie::Service::Cart;

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

Yetie authors.
