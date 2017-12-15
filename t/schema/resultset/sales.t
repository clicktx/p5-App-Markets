use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Test::Deep;

my $t      = Test::Mojo->new('App');
my $app    = $t->app;
my $schema = $app->schema;
my $rs     = $schema->resultset('Sales');

subtest 'method get_id_by_shipment_id()' => sub {
    is $rs->get_id_by_shipment_id(2),   1,     'right id';
    is $rs->get_id_by_shipment_id(3),   2,     'right id';
    is $rs->get_id_by_shipment_id(999), undef, 'right not found';
};

subtest 'method find_by_id()' => sub {
    _find_tests( $rs->find_by_id(1) );
};

subtest 'method find_by_shipment_id()' => sub {
    _find_tests( $rs->find_by_shipment_id(2) );
};

sub _find_tests {
    my $res = shift;

    is $res->id,         1, 'right id';
    is $res->address_id, 1, 'right address_id';
    cmp_deeply $res->{related_resultsets},
      {
        billing_address => ignore(),
        customer        => ignore(),
        orders       => ignore(),
      },
      'right related_resultsets';

    $res->orders->each(
        sub {
            my ( $shipment, $num ) = @_;
            cmp_deeply $shipment->{related_resultsets},
              {
                shipping_address => ignore(),
                items            => ignore(),
              },
              'right shipment no.' . $num . ' related_resultsets';
        }
    );

    my @items = $res->orders->first->items;
    is @items, 2, 'right shipping items';

    $res = $rs->find_by_id(999);
    ok !$res, 'right not found';
}

done_testing();
