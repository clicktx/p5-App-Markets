package t::pages::cart;

use Mojo::Base 't::pages::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub basic : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/cart')->status_is(200)->content_like(qr/cart/i);
    $t->post_ok('/cart')->status_is(404);

    my $post_data = { csrf_token => $self->csrf_token, };
    $t->post_ok( '/cart/edit', form => $post_data )->status_is(200);
}

__PACKAGE__->runtests;
