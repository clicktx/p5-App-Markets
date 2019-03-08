package t::service::activity;

use Mojo::Base 't::common';
use t::Util;
use Test::More;
use Test::Mojo;
use Test::Exception;

sub _init {
    my $self = shift;
    my $c    = $self->t->app->build_controller;
    return ( $c, $c->service('activity') );
}

sub t00_startup : Tests(startup) { shift->app->routes->any('/:controller/:action')->to() }

sub t01_create_domain_entity : Tests() {
    my $self = shift;
    my ( $c, $s ) = $self->_init;

    my $e = $s->create_domain_entity( foo => { customer_id => 111 } );
    isa_ok $e, 'Yetie::Domain::Entity::Activity';
}

sub t02_customer : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/test/add_for_customer')->status_is(200);
}

__PACKAGE__->runtests;

package Yetie::Controller::Catalog::Test;
use Mojo::Base 'Yetie::Controller::Catalog';
use Test::More;

sub add_for_customer {
    my $c = shift;

    $c->service('activity')->add(
        activity_name => {
            customer_id => 111
        }
    );
    $c->render( text => 1 );
}
