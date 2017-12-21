use Mojo::Base -strict;
use t::Util;
use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('App');

subtest 'found category' => sub {
    my $f = $t->app->factory('entity-category');
    my $e = $f->build( 1, { page => 1, rows => 2 } );
    is $e->id,    1,        'right ID';
    is $e->title, 'Sports', 'right title';
    is $e->parent_id, undef, 'right parent_id';
    isa_ok $e->breadcrumb, 'Yetie::Domain::Collection';

    # NOTE: entityを生成していない。
    isa_ok $e->products, 'Yetie::Schema::ResultSet::Product';
};

subtest 'not found category' => sub {
    my $f = $t->app->factory('entity-category');
    my $e = $f->build( 999, { page => 1, rows => 2 } );
    is $e->id,    undef, 'right ID';
    is $e->title, '',    'right title';
    isa_ok $e->breadcrumb, 'Yetie::Domain::Collection';
    is $e->products, undef, 'right products';
};

done_testing;
