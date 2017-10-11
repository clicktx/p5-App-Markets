package t::pages::admin::orders;

use Mojo::Base 't::pages::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub t00_login : Tests() { shift->admin_loged_in }

sub t01_index : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/admin/orders')->status_is(200)->content_like(qr/Orders/);
}

sub t02_detail : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/admin/orders/detail/1')->status_is(200)->content_like(qr/Order Details/);
    $t->get_ok('/admin/orders/detail/99999')->status_is(404);
}

sub t03_edit : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/admin/orders/detail/1/edit')->status_is(200);

    # $t->get_ok('/admin/orders/detail/99999/edit')->status_is(404);
}

sub t04_delete : Tests() {
    my $self = shift;
    my $t    = $self->t;

    my $post_data = {
        csrf_token => $self->csrf_token,
        id         => 2,
    };

    $t->post_ok( '/admin/orders/delete', form => $post_data )->status_is(200, 'right found shipment order');

    $post_data->{id} = 99999;
    $t->post_ok( '/admin/orders/delete', form => $post_data )->status_is(404, 'right not found shipment order');
}

__PACKAGE__->runtests;
