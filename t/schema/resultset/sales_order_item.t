use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

use_ok 'Yetie::Schema::ResultSet::SalesOrderItem';

my $t   = Test::Mojo->new('App');
my $app = $t->app;
my $rs  = $app->schema->resultset('SalesOrderItem');

subtest store_items => sub {
    my $detail = $app->factory('entity-order_detail')->construct(
        id    => 1,
        items => [
            {
                id         => 1,
                product_id => 3,
                price      => {
                    value => 300,
                },
                quantity => 1,
                tax_rule => { id => 2 },
            },
            {
                id         => 99,
                product_id => 2,
                price      => {
                    value => 100,
                },
                quantity => 99,
                tax_rule => { id => 2 },
            },
        ]
    );
    $rs->store_items($detail);

    my $item = $rs->find(1);
    is $item->quantity, 1, 'right update';

    $item = $rs->find(99);
    ok $item->price == 100, 'right create';
    is $item->currency_code, 'USD', 'right create';
    is $item->quantity,      99,    'right create';
};

done_testing();
