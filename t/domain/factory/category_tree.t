use Mojo::Base -strict;
use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

my $f = $app->factory('entity-category_tree');
my $e = $f->build();

isa_ok $e, 'Yetie::Domain::Entity::CategoryTree';
is @{ $e->children }, 2, 'right children';
isa_ok $e->children->first, 'Yetie::Domain::Entity::CategoryTree::Node';

done_testing;
