package t::pages::admin::order;

use Mojo::Base 't::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub t00_login : Tests() { shift->admin_logged_in }

sub t01_index : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/admin/order/1')->status_is(200)->content_like(qr/Order Details/);
    $t->get_ok('/admin/order/999')->status_is(404);
}

sub t02_edit : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/admin/order/1/edit')->status_is(200);
    $t->get_ok('/admin/order/999/edit')->status_is(404);
}

sub t03_duplicate : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/admin/order/1/duplicate')->status_is(200);
    $t->get_ok('/admin/order/999/duplicate')->status_is(404);
}

#
# sub t04_delete : Tests() {
#     my $self = shift;
#     my $t    = $self->t;
#
#     my $order_id = 3;    # NOTE: duplicateで生成された最新のidを取得する。
#     my $post_data   = {
#         csrf_token => $self->csrf_token,
#         id         => $order_id,
#     };
#
#     $t->post_ok( '/admin/order/delete', form => $post_data )->status_is( 200, 'right found shipment order' );
#
#     $post_data->{id} = 999;
#     $t->post_ok( '/admin/order/delete', form => $post_data )->status_is( 404, 'right not found shipment order' );
# }

__PACKAGE__->runtests;
