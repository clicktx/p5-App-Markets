package t::service::cart;

use Mojo::Base 't::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub t00_startup : Tests(startup) { shift->app->routes->any('/:controller/:action')->to() }

sub t01_add_item : Tests() {
    my $self = shift;
    my $t    = $self->t;

    my $params = { product_id => 1, quantity => 1, csrf_token => $self->csrf_token };
    $t->post_ok( '/test/add_item', form => $params )->status_is(200);
}

sub t02_find_cart : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/test/find_cart')->status_is(200);
}

# sub t03_merge_cart : Tests() {}

__PACKAGE__->runtests;

package Yetie::Controller::Catalog::Test;
use Mojo::Base 'Yetie::Controller::Catalog';
use Test::More;
use Test::Deep;

sub get_csrf_token {
    my $c = shift;
    $c->render( text => $c->csrf_token );
}

sub add_item {
    my $c = shift;

    subtest 'items' => sub {
        $c->service('cart')->add_item( { product_id => 1, quantity => 1 } );
        cmp_deeply $c->cart->items->last->to_data,
          {
            product_id    => 1,
            product_title => 'test product1',
            quantity      => 1,
            price         => { value => '100.0000', currency_code => 'USD', is_tax_included => 0 },
            tax_rule      => ignore(),
          },
          'right add cart';
    };
    $c->render( text => 1 );
}

sub find_cart {
    my $c = shift;

    subtest 'find_cart' => sub {
        my $customer_cart = $c->service('cart')->find_cart('111');
        isa_ok $customer_cart, 'Yetie::Domain::Entity::Cart';
    };
    $c->render( text => 1 );
}

