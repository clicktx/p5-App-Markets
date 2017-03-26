package Markets::DefaultHelpers;
use Mojo::Base 'Mojolicious::Plugin';

use Carp         ();
use Scalar::Util ();
use Mojo::Util   ();

sub register {
    my ( $self, $app, $conf ) = @_;

    # Alias helpers
    # $app->helper( schema         => sub { shift->app->schema } ); # controllerから呼ばない
    $app->helper( addons         => sub { shift->app->addons(@_) } );
    $app->helper( cookie_session => sub { shift->session(@_) } );
    $app->helper( template       => sub { shift->stash( template => shift ) } );

    $app->helper( factory => sub { _factory(@_) } );
    $app->helper( pref    => sub { _pref(@_) } );
    $app->helper( service => sub { _service(@_) } );
}

sub _factory {
    my ( $self, $ns ) = ( shift, shift );
    $ns = Mojo::Util::camelize($ns) if $ns =~ /^[a-z]/;
    Carp::croak 'Argument empty.' unless $ns;

    my $factory_base_class = 'Markets::Domain::Factory';
    my $factory_class      = $factory_base_class . '::' . $ns;
    my $domain_class       = 'Markets::Domain::' . $ns;

    my $e = Mojo::Loader::load_class($factory_class);
    die "Exception: $e" if ref $e;

    _load_class($domain_class);

    my $app = $self->app;
    my $params = @_ ? @_ > 1 ? {@_} : { %{ $_[0] } } : {};
    $params->{app}             = $self->app;
    $params->{construct_class} = $domain_class;

    # factory classが無い場合はデフォルトのfactory classを使用
    return $e ? $factory_base_class->new($params) : $factory_class->new($params);
}

sub _pref {
    my $self = shift;
    my $pref = $self->stash('pref');

    @_ ? my $key = shift : return $pref;
    unless ( $pref->{$key} ) {
        my $e = "pref('$key') has not value.";
        $self->app->log->fatal($e);
        Carp::croak $e;
    }
    return $pref->{$key};
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
        _load_class($class);
        $service = $class->new($self);
        $self->app->{services}{$ns} = $service;
    }
    return $service;
}

sub _load_class {
    my $class = shift;

    if ( my $e = Mojo::Loader::load_class($class) ) {
        die ref $e ? "Exception: $e" : "$class not found!";
    }
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

=head2 C<pref>

    my $preferences = $c->pref; # Get all preferences
    my $hoge = $c->pref('hoge');

Get preference.

=head2 C<factory>

    my $something = $c->factory('entity-something', $arg);

    # Markets::Factory::Entity::Something->new($arg)
    # or Markets::Entity::Something->new($arg)
    # Return Markets::Entity::Something Object.

Return Object.

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
