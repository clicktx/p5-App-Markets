use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Test::Deep;

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

subtest 'to_data' => sub {
    my $res = $rs->find(1);

    my $d = $res->to_data;
    cmp_deeply $d,
      {
        id                 => ignore(),
        title              => ignore(),
        description        => ignore(),
        price              => ignore(),
        created_at         => ignore(),
        updated_at         => ignore(),
        product_categories => ignore(),
        breadcrumbs        => ignore(),
      },
      'right all data';

    $d = $res->to_data( { no_datetime => 1 } );
    cmp_deeply $d,
      {
        id                 => ignore(),
        title              => ignore(),
        description        => ignore(),
        price              => ignore(),
        product_categories => ignore(),
        breadcrumbs        => ignore(),
      },
      'right option no_datetime';

    $d = $res->to_data( { no_relation => 1 } );
    cmp_deeply $d,
      {
        id          => ignore(),
        title       => ignore(),
        description => ignore(),
        price       => ignore(),
        created_at  => ignore(),
        updated_at  => ignore(),
      },
      'right option no_relation';
};

done_testing();
