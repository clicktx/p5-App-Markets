use Mojo::Base -strict;
use t::Util;
use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('App');
my $f = $t->app->factory('entity-category');

my $e = $f->build( 1, 1, 2 );
is $e->id,    1,        'right ID';
is $e->title, 'Sports', 'right title';
ok $e->breadcrumb, 'right has breadcrumb';
ok $e->products,   'right has products';

done_testing;
