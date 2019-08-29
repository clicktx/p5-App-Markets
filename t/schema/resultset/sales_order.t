use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Test::Deep;

my $t      = Test::Mojo->new('App');
my $app    = $t->app;
my $schema = $app->schema;
my $rs     = $schema->resultset('SalesOrder');

subtest 'find_by_id' => sub {
    my $res = $rs->find_by_id(1);
    is $res->id,                  1, 'right id';
    is $res->sales_id,            1, 'right sales_id';
    is $res->shipping_address_id, 1, 'right shipping address id';
    cmp_deeply $res->{related_resultsets},
      {
        sales            => ignore(),
        shipping_address => ignore(),
        items            => ignore(),
      },
      'right related_resultsets';
    cmp_deeply $res->sales->{related_resultsets},
      {
        customer        => ignore(),
        billing_address => ignore(),
      },
      'right customer lated_resultsets';

    $res = $rs->find_by_id(999);
    ok !$res, 'right not found';

    $res = $rs->find_by_id(9);
    ok !$res, 'right trashed';
};

subtest 'search_sales_orders' => sub {
    my $args = {
        where    => '',
        order_by => { -asc => 'me.id' },
        page_no  => 1,
        per_page => 3,
    };
    my $itr = $rs->search_sales_orders($args);
    is $itr->count, 3, 'right count';
    isa_ok $itr->pager, 'DBIx::Class::ResultSet::Pager', 'right pager';

    my $row = $itr->first;
    is $row->id,                  1, 'right id';
    is $row->sales_id,            1, 'right sales_id';
    is $row->shipping_address_id, 1, 'right shipping address id';
    cmp_deeply $row->{related_resultsets},
      {
        sales            => ignore(),
        shipping_address => ignore(),
        items            => ignore(),
      },
      'right related_resultsets';
    cmp_deeply $row->sales->{related_resultsets},
      {
        customer        => ignore(),
        billing_address => ignore(),
      },
      'right customer lated_resultsets';

    $args->{where} = { 'me.id' => 999 };
    $itr = $rs->search_sales_orders($args);
    is $itr->count, 0, 'right no data';

    $args->{where} = { 'me.id' => 9 };
    $itr = $rs->search_sales_orders($args);
    is $itr->count, 0, 'right trashed';
};

done_testing();
