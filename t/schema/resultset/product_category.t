use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t      = Test::Mojo->new('App');
my $app    = $t->app;
my $schema = $app->schema;
my $rs     = $schema->resultset('ProductCategory');

subtest 'get_primary_category' => sub {
    isa_ok $rs->search( { product_id => 1 } )->get_primary_category, 'Yetie::Schema::Result::Category';
    is $rs->search( { product_id => 999 } )->get_primary_category, undef, 'right not got';
};

subtest 'get_primary_category_id' => sub {
    is $rs->search( { product_id => 1 } )->get_primary_category_id,   3,     'right get primary category id';
    is $rs->search( { product_id => 999 } )->get_primary_category_id, undef, 'right get primary category id';
};

done_testing();
