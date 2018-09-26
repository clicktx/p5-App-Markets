use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

subtest 'garbled characters' => sub {
    my $str = $t->app->schema->resultset('address')->search( { id => 5 } )->first->state;
    is $str, '佐賀県', 'right not garbled';
};

subtest 'front page' => sub {
    $t->get_ok('/')->status_is(200)->content_like(qr/Mojolicious/i);
};

subtest 'admin page' => sub {
    $t->get_ok('/admin')->status_is(302);
};

done_testing();
