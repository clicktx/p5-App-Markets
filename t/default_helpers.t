use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

subtest 'domain_cache' => sub {
    my $c = $app->build_controller;

    isa_ok $c->domain_cache, 'Mojo::Cache';
    is $c->domain_cache('foo'), undef, 'right no cache';

    $c->domain_cache( 'foo' => 1 );
    is $c->domain_cache('foo'), 1, 'right add cache';

    $c->domain_cache( 'foo' => 5 );
    is $c->domain_cache('foo'), 5, 'right replace cache';

    $c->domain_cache( 'bar' => 7 );
    is $c->domain_cache('bar'), 7, 'right other cache';
};

done_testing();

__END__
