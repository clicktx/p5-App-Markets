use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Test::Deep;

my $t      = Test::Mojo->new('App');
my $app    = $t->app;
my $schema = $app->schema;
my $rs     = $schema->resultset('Category');

subtest 'descendant_ids' => sub {
    my $res = $rs->find(1);
    my $ids = $res->descendant_ids;
    is_deeply $ids, [ 1, 3, 4 ], 'right descendant categories IDs';
};

subtest 'search_products_in_categories' => sub {
    my $res = $rs->find(1);

    my $products_rs = $res->search_products_in_categories( page => 1, rows => 3 );
    isa_ok $products_rs, 'Yetie::Schema::ResultSet::Product';
    is $products_rs->all, 3, 'right arguments hash';

    $products_rs = $res->search_products_in_categories( { page => 1, rows => 1 } );
    is $products_rs->all, 1, 'right arguments hashref';
};

subtest 'to_data' => sub {
    my $res  = $rs->find(1);
    my $data = $res->to_data;

    is_deeply $data,
      {
        id       => 1,
        level    => 0,
        root_id  => 1,
        title    => 'Sports',
        children => [
            {
                id       => 3,
                level    => 1,
                root_id  => 1,
                title    => 'Golf',
                children => [],
            },
            {
                id       => 4,
                level    => 1,
                root_id  => 1,
                title    => 'Soccer',
                children => [],
            },
        ],
      },
      'right data';

    $data = $res->to_data( { no_children => 1 } );
    is_deeply $data,
      {
        id      => 1,
        level   => 0,
        root_id => 1,
        title   => 'Sports',
      },
      'right option';
};

subtest 'to_breadcrumbs' => sub {
    my $res    = $rs->find(3);
    my $crumbs = $res->to_breadcrumbs;

    cmp_deeply $crumbs,
      [
        {
            title => 'Sports',
            url   => obj_isa('Mojo::URL'),
        },
        {
            class => 'current',
            title => 'Golf',
            url   => obj_isa('Mojo::URL'),
        },
      ],
      'right deeply';
};

done_testing();
