use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t      = Test::Mojo->new('App');
my $app    = $t->app;
my $schema = $app->schema;
my $rs     = $schema->resultset('Sales::OrderHeader');

subtest 'is_multiple_shipment' => sub {
    my $res = $rs->find_by_id(1);
    ok $res->is_multiple_shipment, 'right multiple shipments';

    $res = $rs->find_by_id(2);
    ok !$res->is_multiple_shipment, 'right single shipment';
};

done_testing();
