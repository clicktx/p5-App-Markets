use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

use_ok 'Yetie::Schema::ResultSet::SalesOrderItem';

my $t   = Test::Mojo->new('App');
my $app = $t->app;
my $rs  = $app->schema->resultset('SalesOrderItem');

subtest store_item => sub {
    $rs->store_item(
        {
            order_id   => 1,
            product_id => 1,
            quantity   => 4,
            price      => {
                currency_code   => "USD",
                is_tax_included => 0,
                tax_rule_id     => 2,
                value           => 444,
            },
        }
    );

    my $last_id = $rs->last_id;
    my $item    = $rs->find($last_id);
    is $item->quantity, 4, 'right quantity';
    ok $item->price->value == 444, 'right price value';

    # Update
    $rs->store_item(
        {
            id         => $last_id,
            order_id   => 1,
            product_id => 1,
            quantity   => 7,
            price      => {
                currency_code   => "JPY",
                is_tax_included => 0,
                tax_rule_id     => 2,
                value           => 777,
            },
        }
    );

    $item = $rs->find($last_id);
    is $item->quantity, 7, 'right quantity';
    ok $item->price->value == 777, 'right price value';
    is $item->price->currency_code, 'JPY', 'currency_code';
};

done_testing();
