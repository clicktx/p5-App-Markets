use Mojo::Base -strict;
use t::Util;
use Test::More;
use Test::Mojo;
use DDP;

my $t   = Test::Mojo->new('App');
my $app = $t->app;
$t->ua->max_redirects(1);

# 商品ページ
$t->get_ok('/product/1')->status_is(200)->content_like(qr/product/i);

# CSRF token
my $v = t::Util::get_cookie_values( $t => 'session' );
my $csrf_token = $v->{csrf_token};

# カートに商品追加
my $post_data = {
    csrf_token => $csrf_token,
    product_id => 1,
    quantity   => 2,
};
$t->post_ok( '/product/1', form => $post_data )->status_is(200);
my ($url) = map { $_->req->url->path } @{ $t->tx->redirects };
is $url, '/product/1', 'right post to get';

my $sid            = t::Util::get_sid($t);
my $server_session = t::Util::server_session($app);
$server_session->load($sid);

delete $post_data->{csrf_token};
is_deeply $server_session->cart->data->{items}->[0], $post_data, 'right add item';

done_testing;
