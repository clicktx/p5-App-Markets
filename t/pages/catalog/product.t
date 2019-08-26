package t::pages::catalog::product;

use Mojo::Base 't::common';
use t::Util;
use Test::More;
use Test::Deep;
use Test::Mojo;

sub t01_basic : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/product/1')->status_is(200)->content_like(qr/test product1/);
    $t->get_ok('/product/999')->status_is(404);
}

sub t02_add_item : Tests() {
    my $self = shift;
    my $t    = $self->t;

    # Add items
    my $post_data = {
        csrf_token => $self->csrf_token,
        product_id => 1,
        quantity   => 2,
    };
    $t->post_ok( '/product/1', form => $post_data )->status_is(200);
    my ($url) = map { $_->req->url->path } @{ $t->tx->redirects };
    is $url, '/product/1', 'right post to get';

    my $server_session = $self->server_session;
    delete $post_data->{csrf_token};
    cmp_deeply $server_session->cart->data->{items}->[0],
      {
        product_id    => 1,
        product_title => 'test product1',
        quantity      => 2,
        price         => ignore(),
        tax_rule      => ignore(),
      },
      'right add item';

    # Bad parameters
    $t->ua->max_redirects(0);
    $post_data = {
        csrf_token => $self->csrf_token,
        product_id => 1,
        quantity   => 0,
    };
    $t->post_ok( '/product/1', form => $post_data )->status_is(200);

    $post_data->{quantity} = 'a';
    $t->post_ok( '/product/1', form => $post_data )->status_is(200);
}

__PACKAGE__->runtests;
