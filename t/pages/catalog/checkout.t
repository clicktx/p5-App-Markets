package t::pages::catalog::checkout;

use Mojo::Base 't::common';
use t::Util;
use Test::More;
use Test::Deep;
use Test::Mojo;
use DDP;

my $CART_DATA = {
    items => [
        { product_id => 2, quantity => 2, price => 200 },
        { product_id => 1, quantity => 1, price => 100 },
        { product_id => 3, quantity => 3, price => 300 },
    ],
    shipments => [],
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
sub test_01_01_no_logged_in : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/checkout')->status_is(200);
    is_deeply $t->tx->redirects, [], 'right no redirects';

    $t->get_ok($_)->status_is(200)->element_exists('form[action=/login]')
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

sub test_01_02_index_after_logged_in : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $self->customer_loggin;

    $t->get_ok('/checkout')->status_is(200);
    my ($url) = map { $_->req->url->path } @{ $t->tx->redirects };
    is $url, $self->app->url_for('rn.checkout'), 'right redirect';
}

sub test_02_shipping_address : Tests() {
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

sub test_03_billing_address : Tests() {
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

sub test_04_select_address : Tests() {
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

__PACKAGE__->runtests;
