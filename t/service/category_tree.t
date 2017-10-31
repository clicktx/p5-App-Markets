use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;
use_ok 'Markets::Service::CategoryTree';

subtest 'basic' => sub {
    my $c       = $app->build_controller;
    my $service = $c->service('category_tree');

    can_ok $service, 'create_entity';
};

subtest 'create_entity' => sub {
    my $c       = $app->build_controller;
    my $service = $c->service('category_tree');

    my $tree = $service->create_entity();
    isa_ok $tree, 'Markets::Domain::Entity::CategoryTree';
};

subtest 'get_entity' => sub {
    my $c       = $app->build_controller;
    my $service = $c->service('category_tree');

    is $c->entity_cache('category_tree'), undef, 'right not cache';

    my $tree = $service->get_entity();
    isa_ok $tree, 'Markets::Domain::Entity::CategoryTree';
    ok $c->entity_cache('category_tree'), 'right cache';
};

done_testing();

__END__
