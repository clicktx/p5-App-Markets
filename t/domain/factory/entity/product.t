use Mojo::Base -strict;
use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

subtest 'found product' => sub {
    my $f = $app->factory('entity-product');
    my $e = $f->build(1);
    is $e->id, 1, 'right id';
    isa_ok $e->product_categories, 'Yetie::Domain::Collection';
    isa_ok $e->breadcrumb,         'Yetie::Domain::Collection';
    is @{ $e->breadcrumb }, 2, 'right breadcrumb';
    isa_ok $e->created_at, 'DateTime';
    isa_ok $e->updated_at, 'DateTime';
};

subtest 'not found product' => sub {
    my $f = $app->factory('entity-product');
    my $e = $f->build(999);

    is $e->id, undef, 'right id';
    is @{ $e->product_categories }, 0, 'right product categories';
    is $e->created_at, undef, 'right created';
    is $e->updated_at, undef, 'right updated';
};

done_testing;
