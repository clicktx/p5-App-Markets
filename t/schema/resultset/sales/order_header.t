use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Test::Deep;

my $t      = Test::Mojo->new('App');
my $app    = $t->app;
my $schema = $app->schema;
my $rs     = $schema->resultset('Sales::OrderHeader');

subtest 'method find_by_id()' => sub {
    my $res = $rs->find_by_id(1);

    is $res->id,         1, 'right id';
    is $res->address_id, 1, 'right address_id';
    cmp_deeply $res->{related_resultsets},
      {
        billing_address => ignore(),
        customer        => ignore(),
        shipments       => ignore(),
      },
      'right related_resultsets';

    $res->shipments->each(
        sub {
            my ( $shipment, $num ) = @_;
            cmp_deeply $shipment->{related_resultsets},
              {
                shipping_address => ignore(),
                shipping_items   => ignore(),
              },
              'right shipment no.' . $num . ' related_resultsets';
        }
    );

    my @shipping_items = $res->shipments->first->shipping_items;
    is @shipping_items, 2, 'right shipping_items';

    $res = $rs->find_by_id(999);
    ok !$res, 'right not found';
};

done_testing();
