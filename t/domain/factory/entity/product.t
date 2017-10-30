use Mojo::Base -strict;
use t::Util;
use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('App');
my $f = $t->app->factory('entity-product');

my $e = $f->build(1);
is $e->id, 1, 'right id';
isa_ok $e->primary_category,   'Markets::Domain::Collection';
isa_ok $e->product_categories, 'Markets::Domain::Collection';
isa_ok $e->created_at,         'DateTime';
isa_ok $e->updated_at,         'DateTime';

$e = $f->build(999);
is $e, undef, 'right not found';

done_testing;
