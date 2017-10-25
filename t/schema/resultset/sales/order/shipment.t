use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Test::Deep;

my $t      = Test::Mojo->new('App');
my $app    = $t->app;
my $schema = $app->schema;
my $rs     = $schema->resultset('Sales::Order::Shipment');

subtest 'method find_by_id()' => sub {
    my $res = $rs->find_by_id(1);
    is $res->id,              1, 'right id';
    is $res->order_header_id, 1, 'right order_header_id';
    is $res->address_id,      1, 'right address_id';
    cmp_deeply $res->{related_resultsets},
      {
        order_header     => ignore(),
        shipping_address => ignore(),
        shipping_items   => ignore(),
      },
      'right related_resultsets';
    cmp_deeply $res->order_header->{related_resultsets},
      {
        customer        => ignore(),
        billing_address => ignore(),
      },
      'right customer lated_resultsets';

    $res = $rs->find_by_id(111);
    ok !$res, 'right not found';
};

subtest 'method search_sales_list()' => sub {
    my $args = {
        where    => '',
        order_by => { -asc => 'me.id' },
        page_no  => 1,
        rows     => 3,
    };
    my $itr = $rs->search_sales_list($args);
    is $itr->count, 3, 'right count';
    isa_ok $itr->pager, 'DBIx::Class::ResultSet::Pager', 'right pager';

    my $row = $itr->first;
    is $row->id,              1, 'right id';
    is $row->order_header_id, 1, 'right order_header_id';
    is $row->address_id,      1, 'right address_id';
    cmp_deeply $row->{related_resultsets},
      {
        order_header     => ignore(),
        shipping_address => ignore(),
      },
      'right related_resultsets';
    cmp_deeply $row->order_header->{related_resultsets},
      {
        customer        => ignore(),
        billing_address => ignore(),
      },
      'right customer lated_resultsets';

    $args->{where} = { 'me.id' => 999 };
    $itr = $rs->search_sales_list($args);
    is $itr->count, 0, 'right count';
};

done_testing();
