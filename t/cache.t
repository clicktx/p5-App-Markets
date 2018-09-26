use Mojo::Base -strict;

use Test::More;
my $pkg = 'Yetie::Cache';
use_ok $pkg;

subtest 'clear_all' => sub {
    my $cache = $pkg->new;
    $cache->set( foo => 'bar' );
    $cache->set( baz => 'bar' );
    isa_ok $cache->clear_all, 'Yetie::Cache';
    is $cache->get('foo'), undef, 'right clear foo';
    is $cache->get('baz'), undef, 'right clear baz';
};

done_testing();
