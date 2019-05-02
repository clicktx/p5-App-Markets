package t::pages::admin::order_edit;

use Mojo::Base 't::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub startup : Test(startup) {
    my $self = shift;
    $self->SUPER::startup;
    $self->t->ua->max_redirects(0);
}

sub t00_login : Tests() { shift->admin_loggin }

sub t01_billing_address : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/admin/order/1/edit/billing_address')->status_is(200);
    $t->get_ok('/admin/order/999/edit/billing_address')->status_is(404);

    my $post_data = { csrf_token => $self->csrf_token };
    $t->post_ok( '/admin/order/1/edit/billing_address', form => $post_data )
      ->status_is( 200, 'right billing_address post validate error' );

    $post_data = {
        csrf_token                      => $self->csrf_token,
        'billing_address.country_code'  => 'us',
        'billing_address.line1'         => '42 Pendergast St.',
        'billing_address.city'          => 'Piedmont',
        'billing_address.state'         => 'SC',
        'billing_address.postal_code'   => '29673',
        'billing_address.personal_name' => 'Elizabeth T. Peoples',
        'billing_address.organization'  => 'Eli Moore Inc',
        'billing_address.phone'         => '305-939-8498',
    };
    $t->post_ok( '/admin/order/1/edit/billing_address', form => $post_data )
      ->status_is( 200, 'right update billing_address' );
}

sub t02_shipping_address : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/admin/order/1/edit/shipping_address')->status_is(200);
    $t->get_ok('/admin/order/999/edit/shipping_address')->status_is(404);

    my $post_data = { csrf_token => $self->csrf_token };
    $t->post_ok( '/admin/order/1/edit/shipping_address', form => $post_data )
      ->status_is( 200, 'right shipping_address post validate error' );
}

sub t03_items_orderd : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/admin/order/1/edit/items')->status_is(200);
    $t->get_ok('/admin/order/999/edit/items')->status_is(404);

    my $post_data = {
        csrf_token          => $self->csrf_token,
        'item.{1}.quantity' => '',
        'item.{1}.price'    => '',
    };
    $t->post_ok( '/admin/order/1/edit/items', form => $post_data )->status_is( 200, 'right items post validate error' );

    $post_data->{'item.{1}.quantity'} = 3;
    $post_data->{'item.{1}.price'}    = 300;
    $t->post_ok( '/admin/order/1/edit/items', form => $post_data )->status_is( 302, 'right items update' );
}

__PACKAGE__->runtests;
