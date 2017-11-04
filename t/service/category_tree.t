use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

subtest 'get_entity' => sub {
    my $c       = $app->build_controller;
    my $service = $c->service('category_tree');

    is $c->entity_cache('category_tree'), undef, 'right not cache';

    my $tree = $service->get_entity();
    isa_ok $tree, 'Markets::Domain::Entity::CategoryTree';

    my $cache = $c->entity_cache('category_tree');
    ok $cache,     'right cache';
    isa_ok $cache, 'Markets::Domain::Entity::CategoryTree';
};

done_testing();

__END__
