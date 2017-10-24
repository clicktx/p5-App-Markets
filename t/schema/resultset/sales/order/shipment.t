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

    $res = $rs->find_by_id(111);
    ok !$res, 'right not found';
};

done_testing();
