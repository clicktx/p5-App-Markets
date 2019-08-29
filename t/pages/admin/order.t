package t::pages::admin::order;

use Mojo::Base 't::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub t00_login : Tests() { shift->admin_loggin }

sub t01_index : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/admin/order/1')->status_is(200)->content_like(qr/Order Details/);
    $t->get_ok('/admin/order/999')->status_is(404);
}

sub t02_duplicate : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/admin/order/1/duplicate')->status_is(200);
    $t->get_ok('/admin/order/999/duplicate')->status_is(404);
}

sub t03_trash : Tests() {
    my $self = shift;
    my $t    = $self->t;

    my $order_id  = 12;
    my $post_data = {
        csrf_token => $self->csrf_token,
        id         => $order_id,
    };

    $t->post_ok( '/admin/order/trash', form => $post_data )->status_is( 200, 'right order trashed' );
    $t->get_ok('/admin/order/12')->status_is(404);

    $post_data->{id} = 999;
    $t->post_ok( '/admin/order/trash', form => $post_data )->status_is( 400, 'right bad request' );
}

__PACKAGE__->runtests;
