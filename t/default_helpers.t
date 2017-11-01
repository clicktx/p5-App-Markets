use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

subtest 'entity_cache' => sub {
    my $c = $app->build_controller;

    is $c->entity_cache('hoge'), undef, 'right no cache';

    $c->entity_cache( 'hoge' => 1 );
    is $c->entity_cache('hoge'), 1, 'right add cache';

    my $cache = $c->entity_cache( 'hoge' => 5 );
    is $c->entity_cache('hoge'), 5, 'right replace cache';
    is $cache, 5, 'right return value';
};

done_testing();

__END__
