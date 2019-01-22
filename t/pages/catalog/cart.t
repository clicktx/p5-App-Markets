package t::pages::catalog::cart;

use Mojo::Base 't::pages::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub basic : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/cart')->status_is(200)->content_like(qr/cart/i);
    $t->post_ok( '/cart', form => { csrf_token => $self->csrf_token } )->status_is(200);

    $t->post_ok( '/cart/clear', form => { csrf_token => $self->csrf_token } )->status_is(200);
    $t->post_ok(
        '/cart/delete',
        form => {
            csrf_token     => $self->csrf_token,
            target_item_id => 'aaabbbccc',
        }
    )->status_is(200);
}

__PACKAGE__->runtests;
