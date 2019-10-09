package t::service::checkout;

use Mojo::Base 't::common';
use t::Util;
use Test::Mojo;

sub t00_startup : Tests(startup) { shift->app->routes->any('/:controller/:action')->to() }

sub t01_basic : Tests() {
    my $self = shift;
    my $t    = $self->t;
    $t->get_ok('/test/basic_method')->status_is(200);
}

sub t02_add_all_cart_items : Tests() {
    my $self = shift;
    my $t    = $self->t;
    $t->get_ok('/test/add_all_cart_items')->status_is(200);
}

__PACKAGE__->runtests;

package Yetie::Controller::Catalog::Test;
use Mojo::Base 'Yetie::Controller::Catalog';
use Test::More;
use Test::Deep;

sub basic_method {
    my $c = shift;

    my $checkout = $c->service('checkout')->get;
    isa_ok $checkout, 'Yetie::Domain::Entity::Checkout';
    is $checkout->shipments->size, 1, 'right new shipment in shipments';
    is_deeply $c->server_session->data('checkout'), {}, 'right get';
    ok $c->stash('checkout'), 'right stash';

    $c->service('checkout')->save;
    cmp_deeply $c->server_session->data('checkout'),
      {
        billing_address => ignore(),
        shipments       => ignore(),
        transaction     => ignore(),
      },
      'right update';
    is $c->stash('checkout'), $checkout, 'right equals object for stash';

    $c->service('checkout')->delete;
    cmp_deeply $c->server_session->data('checkout'), undef, 'right delete';

    return $c->render( text => 1 );
}

sub add_all_cart_items {
    my $c        = shift;
    my $checkout = $c->service('checkout')->get;

    # Cart in
    $c->service('cart')->add_item( { product_id => 1, quantity => 1 } );
    $c->service('cart')->add_item( { product_id => 2, quantity => 2 } );

    # Add shipping address
    my $shipment = $checkout->factory('entity-address')->construct( country_code => 'jp' );
    $checkout->set_shipping_address($shipment);

    my $items = $c->cart->items;
    $c->service('checkout')->add_all_cart_items();
    cmp_deeply $items->to_data, $checkout->shipments->first->items->to_data, 'right items';

    return $c->render( text => 1 );
}

1;
