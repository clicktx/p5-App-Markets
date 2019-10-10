use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t      = Test::Mojo->new('App');
my $app    = $t->app;
my $schema = $app->schema;
my $rs     = $schema->resultset('Sales');

subtest 'is_multiple_shipping' => sub {
    my $res = $rs->find_by_id(1);
    ok $res->is_multiple_shipping, 'right multiple shipments';

    $res = $rs->find_by_id(2);
    ok !$res->is_multiple_shipping, 'right single shipment';
};

done_testing();
