package t::pages::product;

use Mojo::Base 't::pages::common';
use t::Util;
use Test::More;
use Test::Mojo;
use DDP;

sub add_item : Tests() {
    my $self = shift;
    my $t    = $self->t;

    # 商品ページ
    $t->get_ok('/product/1')->status_is(200)->content_like(qr/product/i);

    # カートに商品追加
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
    is_deeply $server_session->cart->data->{items}->[0],
      {
        product_id    => 1,
        product_title => 'test product1',
        quantity      => 2,
        price         => 100,
      },
      'right add item';
}

__PACKAGE__->runtests;
