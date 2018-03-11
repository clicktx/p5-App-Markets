use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

subtest 'search_all and get_cache' => sub {
    my $c       = $app->build_controller;
    my $service = $c->service('category_tree');

    is $service->get_cache, undef, 'right not cached';

    my $tree = $service->search_all();
    isa_ok $tree, 'Yetie::Domain::Entity::CategoryTree';

    my $cache = $service->get_cache;
    ok $cache,     'right cache';
    isa_ok $cache, 'Yetie::Domain::Entity::CategoryTree';
};

done_testing();

__END__
