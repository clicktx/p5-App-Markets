use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

subtest 'cache' => sub {
    my $c = $app->build_controller;

    isa_ok $c->cache, 'Mojo::Cache';
    is $c->cache('foo'), undef, 'right no cache';

    $c->cache( 'foo' => 1 );
    is $c->cache('foo'), 1, 'right add cache';

    $c->cache( 'foo' => 5 );
    is $c->cache('foo'), 5, 'right replace cache';

    $c->cache( 'bar' => 7 );
    is $c->cache('bar'), 7, 'right other cache';
};

done_testing();

__END__
