use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t      = Test::Mojo->new('App');
my $app    = $t->app;
my $schema = $app->schema;
my $rs     = $schema->resultset('Product');

subtest 'find_primary_category' => sub {
    my $result  = $rs->find_product(1);
    my $primary = $result->find_primary_category;

    isa_ok $primary, 'Yetie::Schema::Result::Category';
    is $primary->id, 3, 'right id';
};

done_testing();
