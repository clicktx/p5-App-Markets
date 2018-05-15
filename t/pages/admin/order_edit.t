package t::pages::admin::order_edit;

use Mojo::Base 't::pages::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub t00_login : Tests() { shift->admin_loged_in }

sub t01_billing_address : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/admin/order/1/edit/billing_address')->status_is(200);
    $t->get_ok('/admin/order/999/edit/billing_address')->status_is(404);
}

sub t02_shipping_address : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/admin/order/1/edit/shipping_address')->status_is(200);
    $t->get_ok('/admin/order/999/edit/shipping_address')->status_is(404);
}

__PACKAGE__->runtests;
