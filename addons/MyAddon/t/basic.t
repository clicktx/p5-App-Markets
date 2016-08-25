use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('Markets::Web');
my $app = $t->app;

subtest 'front page' => sub {
    $t->get_ok('/')->status_is(200)->content_like(qr/Mojolicious/i);
};

subtest 'admin page' => sub {
    $t->get_ok('/admin')->status_is(200)->content_like(qr/Admin/i);
    $t->get_ok('/ja/admin')->status_is(200)->content_like(qr/こんにちはmy-addon/i);
};

done_testing();
