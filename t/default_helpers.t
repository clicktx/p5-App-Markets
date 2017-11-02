use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

subtest 'entity_cache' => sub {
    my $c = $app->build_controller;

    isa_ok $c->entity_cache, 'Mojo::Cache';
    is $c->entity_cache('foo'), undef, 'right no cache';

    $c->entity_cache( 'foo' => 1 );
    is $c->entity_cache('foo'), 1, 'right add cache';

    $c->entity_cache( 'foo' => 5 );
    is $c->entity_cache('foo'), 5, 'right replace cache';

    $c->entity_cache( 'bar' => 7 );
    is $c->entity_cache('bar'), 7, 'right other cache';
};

done_testing();

__END__
