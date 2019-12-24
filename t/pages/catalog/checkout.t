package t::pages::catalog::checkout;

use Mojo::Base 't::common';
use t::Util;
use Test::More;
use Test::Deep;
use Test::Mojo;

my $CART_DATA = {
    items => [
        { product_id => 2, product_title => 'bar', quantity => 2, price => 200 },
        { product_id => 3, product_title => 'baz', quantity => 3, price => 300 },
        { product_id => 1, product_title => 'foo', quantity => 1, price => 100 },
    ],
};

sub startup : Test(startup) {
    my $self = shift;
    $self->SUPER::startup;

    # カートに商品を入れておく
    $self->ua->get('/');
    my $sid            = t::Util::get_sid( $self->t );
    my $server_session = t::Util::server_session( $self->app );
    $server_session->load($sid);
    $server_session->cart->data($CART_DATA);
    $server_session->flush;
}

# NOTE: カートが空の場合のtestも必要
sub test_01_no_logged_in : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/checkout')->status_is(200);
    is_deeply $t->tx->redirects, [], 'right no redirects';

    $t->get_ok($_)->status_is(302)->header_is( Location => '/dropin' )
      for (
        qw(
        /checkout/shipping-address
        /checkout/delivery-options
        /checkout/payment-option
        /checkout/billing-address
        /checkout/confirm
        )
      );
}

sub test_02_index_after_logged_in : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $self->customer_loggin;

    $t->get_ok('/checkout')->status_is(200);
    my ($url) = map { $_->req->url->path } @{ $t->tx->redirects };
    is $url, $self->app->url_for('rn.checkout'), 'right redirect';
}

sub test_03_shipping_address : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/checkout/shipping-address')->status_is(200)->content_like(qr/shipping address/);

    # New address
    my $post_data = {
        csrf_token    => $self->csrf_token,
        country_code  => 'us',
        personal_name => 'foo',
        line1         => 'bar',
        city          => 'baz',
        state         => 'foo',
        postal_code   => 'bar',
        phone         => 'baz',
    };
    $t->post_ok( '/checkout/shipping-address', form => $post_data )->status_is(200)->content_like(qr/billing address/);
}

sub test_04_billing_address : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/checkout/billing-address')->status_is(200)->content_like(qr/billing address/);

    # New address
    my $post_data = {
        csrf_token    => $self->csrf_token,
        country_code  => 'us',
        personal_name => 'foo',
        line1         => 'bar',
        city          => 'baz',
        state         => 'foo',
        postal_code   => 'bar',
        phone         => 'baz',
    };
    $t->post_ok( '/checkout/billing-address', form => $post_data )->status_is(200)->content_like(qr/confirm/);
}

sub test_05_select_address : Tests() {
    my $self = shift;
    my $t    = $self->t;

    my $post_data = {
        csrf_token => $self->csrf_token,
        select_no  => 0,
    };
    $t->post_ok( '/checkout/shipping-address/select', form => $post_data )
      ->status_is( 200, 'right select shipping address' );

    $t->post_ok( '/checkout/billing-address/select', form => $post_data )
      ->status_is( 200, 'right select billing address' );
}

sub test_10_confirm : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/checkout/confirm')->status_is(200)->content_like(qr/confirm/);
}

sub test_20_complete : Tests() {
    my $self = shift;
    my $t    = $self->t;

    my $post_data = { csrf_token => $self->csrf_token, };
    $t->post_ok( '/checkout/confirm', form => $post_data )->status_is(200);
}

sub test_50_stored_data : Tests() {
    my $self = shift;
    my $t    = $self->t;

    my $schema     = $t->app->schema;
    my $rs         = $schema->resultset('SalesOrderItem')->search( {}, { order_by => { -desc => 'id' } } );
    my $last_order = $rs->first;

    ok $last_order->order_id,      'right stored order_id';
    is $last_order->product_id,    1, 'right stored product_id';
    is $last_order->product_title, 'foo', 'right stored product_id';
    is $last_order->quantity,      1, 'right stored quantity';
    ok $last_order->price == 100, 'right stored price';
}

__PACKAGE__->runtests;
